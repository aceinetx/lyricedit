const rl = @import("raylib");
const tfd = @import("tinyfiledialogs");
const im = @import("imgui");

pub fn main() void {
    rl.initWindow(1280, 720, "lyricedit");
    defer rl.closeWindow();

    im.rl.setup(true);
    defer im.rl.shutdown();

    const io: *im.Io = im.getIo();
    io.IniFilename = null;

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
