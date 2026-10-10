const im = @import("imgui");

fn setupImGuiFont() void {
    const io: *im.Io = im.getIo();

    var font_cfg = im.FontConfig_default;
    font_cfg.FontDataOwnedByAtlas = false;

    var builder = im.FontGlyphRangesBuilder_Init();
    im.FontGlyphRangesBuilder_AddRanges(&builder, im.FontAtlas_GetGlyphRangesDefault(io.Fonts));
    im.FontGlyphRangesBuilder_AddRanges(&builder, im.FontAtlas_getGlyphRangesCyrillic(io.Fonts));

    var ranges = im.Vector(im.Wchar){};
    defer im.vectorDestruct(&ranges);

    im.FontGlyphRangesBuilder_BuildRanges(&builder, &ranges);

    const font = @embedFile("assets/nunito.ttf");
    im.FontAtlas_ClearFonts(io.Fonts);
    _ = im.FontAtlas_AddFontFromMemoryTTF(
        io.Fonts,
        @ptrCast(@constCast(font.ptr)),
        font.len,
        20.0,
        &font_cfg,
        ranges.Data,
    );
}

pub fn setupImGui() void {
    const io: *im.Io = im.getIo();
    io.IniFilename = null;

    setupImGuiFont();
}
