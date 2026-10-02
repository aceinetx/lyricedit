const std = @import("std");

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

fn setupImGui(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    raylib: *std.Build.Module,
) *std.Build.Module {
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

        const dcimgui_c = b.addTranslateC(.{
            .root_source_file = b.path("external/dear_bindings_generated/dcimgui.h"),
            .target = target,
            .optimize = optimize,
        });
        dcimgui_c.addIncludePath(b.path("external/imgui"));

        const dcimgui = dcimgui_c.createModule();

        dcimgui.addCSourceFile(.{
            .file = b.path("external/dear_bindings_generated/dcimgui.cpp"),
            .language = .cpp,
        });
        dcimgui.addImport("imgui", imgui);
        dcimgui.addIncludePath(b.path("external/imgui"));

        break :blk dcimgui;
    };

    const rlImGui = blk: {
        const rlImGui_c = b.addTranslateC(.{
            .root_source_file = b.path("external/rlImGui/rlImGui.h"),
            .target = target,
            .optimize = optimize,
        });
        rlImGui_c.addIncludePath(b.path("external/imgui"));
        addRaylibIncludePaths(b, raylib, rlImGui_c);

        const rlImGui = rlImGui_c.createModule();
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

    return imgui;
}

fn setupTinyFileDialogs(
    b: *std.Build,
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
                .module = b.addTranslateC(.{
                    .root_source_file = b.path("external/libtinyfiledialogs/tinyfiledialogs.h"),
                    .target = target,
                    .optimize = optimize,
                }).createModule(),
            },
        },
    });

    tinyfiledialogs.addCSourceFile(.{ .file = b.path("external/libtinyfiledialogs/tinyfiledialogs.c") });

    return tinyfiledialogs;
}

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ----------------------------------------------------------

    const raylib_dep = b.dependency("raylib_zig", .{
        .target = target,
        .optimize = optimize,
    });

    const raylib = raylib_dep.module("raylib");

    const raylib_artifact = raylib_dep.artifact("raylib");

    // ----------------------------------------------------------

    const imgui = setupImGui(b, target, optimize, raylib);

    // ----------------------------------------------------------

    const tinyfiledialogs = setupTinyFileDialogs(b, target, optimize);

    // ----------------------------------------------------------

    const exe = b.addExecutable(.{
        .name = "lyricedit",
        .use_lld = true,
        .use_llvm = true,
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "raylib", .module = raylib },
                .{ .name = "tinyfiledialogs", .module = tinyfiledialogs },
                .{ .name = "imgui", .module = imgui },
            },
        }),
    });
    exe.root_module.linkLibrary(raylib_artifact);

    b.installArtifact(exe);

    // ----------------------------------------------------------

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
}
