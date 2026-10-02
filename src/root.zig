const std = @import("std");
const LRC = @import("lrc.zig").LRC;
const rl = @import("raylib");
const tfd = @import("tinyfiledialogs");
const im = @import("imgui");

fn setupImGuiFont() void {
    const io: *im.Io = im.getIo();

    var font_cfg = im.ImFontConfig_default;
    font_cfg.FontDataOwnedByAtlas = false;

    const font = @embedFile("assets/font.ttf");
    im.ImFontAtlas_ClearFonts(io.Fonts);
    _ = im.ImFontAtlas_AddFontFromMemoryTTF(
        io.Fonts,
        @ptrCast(@constCast(font.ptr)),
        font.len,
        18.0,
        &font_cfg,
        im.ImFontAtlas_GetGlyphRangesDefault(io.Fonts),
    );
}

fn setupImGui() void {
    const io: *im.Io = im.getIo();
    io.IniFilename = null;

    setupImGuiFont();
}

pub fn main(init: std.process.Init) void {
    var lrc = blk: {
        const file = std.Io.Dir.cwd().openFile(init.io, "ronin - tears in reflection.lrc", .{}) catch unreachable;
        defer file.close(init.io);

        var buffer: [2048]u8 = undefined;
        var reader = file.reader(init.io, &buffer);

        break :blk LRC.deserialize(&reader.interface, init.gpa) catch unreachable;
    };
    defer lrc.deinit(init.gpa);

    if (false) {
        rl.initWindow(1280, 720, "lyricedit");
        defer rl.closeWindow();

        im.rl.setup(true);
        defer im.rl.shutdown();

        setupImGui();

        var open = false;

        while (!rl.windowShouldClose()) {
            rl.beginDrawing();
            rl.clearBackground(.black);

            im.rl.begin();
            im.showDemoWindow(&open);
            im.rl.end();

            rl.endDrawing();
        }
    }
}
