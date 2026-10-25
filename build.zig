const std = @import("std");
const Translator = @import("translate_c").Translator;

// #region raylib
fn addRaylibIncludePaths(
    b: *std.Build,
    raylib: *std.Build.Module,
    module: anytype,
) void {
    _ = b;
    for (raylib.include_dirs.items[0].other_step.root_module.include_dirs.items) |dir| {
        // std.log.info("{}", .{dir});
        if (dir == .path) {
            // std.log.warn("{s}", .{dir.path.getPath(b)});
            module.addIncludePath(dir.path);
        }
    }
}
// #endregion

// #region imgui
const ImGui = struct {
    module: *std.Build.Module,
    step: *std.Build.Step,
};

fn setupImGui(
    b: *std.Build,
    translate_c: *std.Build.Dependency,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    raylib: *std.Build.Module,
) ImGui {
    const dear_bindings = b.addSystemCommand(&.{
        "python",
        "external/dear_bindings/dear_bindings.py",
        "-o",
    });
    const dear_bindings_dir = dear_bindings.addOutputDirectoryArg("dcimgui").dirname();
    dear_bindings.addFileArg(b.path("external/imgui/imgui.h"));

    // ----------------------------------------------------------

    const imgui_c = blk: {
        const imgui = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libcpp = true,
        });

        imgui.addIncludePath(b.path("external/imgui"));
        inline for ([_]std.Build.LazyPath{
            b.path("external/imgui/imgui.cpp"),
            b.path("external/imgui/imgui_demo.cpp"),
            b.path("external/imgui/imgui_widgets.cpp"),
            b.path("external/imgui/imgui_draw.cpp"),
            b.path("external/imgui/imgui_tables.cpp"),
        }) |file| {
            imgui.addCSourceFile(.{
                .file = file,
                .language = .cpp,
            });
        }

        // ----------------------------------------------------------

        const dcimgui_c = Translator.init(translate_c, .{
            .c_source_file = dear_bindings_dir.path(b, "dcimgui.h"),
            .target = target,
            .optimize = optimize,
            .default_init = true,
        });

        dcimgui_c.addIncludePath(b.path("external/imgui"));

        const dcimgui = dcimgui_c.mod;

        dcimgui.addCSourceFile(.{
            .file = dear_bindings_dir.path(b, "dcimgui.cpp"),
            .language = .cpp,
        });
        dcimgui.addImport("imgui", imgui);
        dcimgui.addIncludePath(b.path("external/imgui"));

        break :blk dcimgui;
    };

    const rlImGui = blk: {
        const rlImGui_c = Translator.init(translate_c, .{
            .c_source_file = b.path("external/rlImGui/rlImGui.h"),
            .target = target,
            .optimize = optimize,
        });
        rlImGui_c.addIncludePath(b.path("external/imgui"));
        addRaylibIncludePaths(b, raylib, rlImGui_c);

        const rlImGui = rlImGui_c.mod;
        rlImGui.link_libcpp = true;

        rlImGui.addImport("raylib", raylib);
        addRaylibIncludePaths(b, raylib, rlImGui);
        rlImGui.addIncludePath(b.path("external/imgui"));

        rlImGui.addCSourceFile(.{
            .file = b.path("external/rlImGui/rlImGui.cpp"),
            .language = .cpp,
        });
        break :blk rlImGui;
    };

    const imgui = b.createModule(.{
        .root_source_file = b.path("imgui/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "imgui", .module = imgui_c },
            .{ .name = "rlImGui", .module = rlImGui },
        },
    });

    return .{
        .module = imgui,
        .step = &dear_bindings.step,
    };
}
// #endregion

// #region tinyfiledialogs
fn setupTinyFileDialogs(
    b: *std.Build,
    translate_c: *std.Build.Dependency,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) *std.Build.Module {
    const tinyfiledialogs = b.createModule(.{
        .root_source_file = b.path("tinyfiledialogs/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{
                .name = "tinyfiledialogs",
                .module = blk: {
                    const c = Translator.init(translate_c, .{
                        .c_source_file = b.path("tinyfiledialogs/tinyfiledialogs_fix.h"),
                        .target = target,
                        .optimize = optimize,
                    });
                    c.addIncludePath(b.path("external/libtinyfiledialogs"));
                    break :blk c.mod;
                },
            },
        },
    });

    tinyfiledialogs.addIncludePath(b.path("external/libtinyfiledialogs"));
    tinyfiledialogs.addCSourceFile(.{ .file = b.path("tinyfiledialogs/tinyfiledialogs_fix.c") });

    return tinyfiledialogs;
}
// #endregion

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ----------------------------------------------------------

    const translate_c = b.dependency("translate_c", .{});

    // ----------------------------------------------------------

    const raylib_dep = b.dependency("raylib_zig", .{
        .target = target,
        .optimize = optimize,
    });

    const raylib = raylib_dep.module("raylib");

    const raylib_artifact = raylib_dep.artifact("raylib");

    // ----------------------------------------------------------

    const imgui = setupImGui(b, translate_c, target, optimize, raylib);

    // ----------------------------------------------------------

    const tinyfiledialogs = setupTinyFileDialogs(b, translate_c, target, optimize);

    // ----------------------------------------------------------

    const exe = b.addExecutable(.{
        .name = "lyricedit",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "raylib", .module = raylib },
                .{ .name = "tinyfiledialogs", .module = tinyfiledialogs },
                .{ .name = "imgui", .module = imgui.module },
            },
        }),
    });
    exe.root_module.linkLibrary(raylib_artifact);

    if (target.result.os.tag == .windows) {
        exe.root_module.linkSystemLibrary("comdlg32", .{});
        exe.root_module.linkSystemLibrary("ole32", .{});
    }

    exe.step.dependOn(imgui.step);

    b.installArtifact(exe);

    // ----------------------------------------------------------

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    run_cmd.addPassthruArgs();
}
