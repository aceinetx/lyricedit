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

pub fn setupImGui() void {
    const io: *im.Io = im.getIo();
    io.IniFilename = null;

    setupImGuiFont();
}
