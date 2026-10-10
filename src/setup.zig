const im = @import("imgui");

fn setupImGuiFont() void {
    const io: *im.Io = im.getIo();

    var font_cfg = im.ImFontConfig_default;
    font_cfg.FontDataOwnedByAtlas = false;

    var builder = im.ImFontGlyphRangesBuilder_Init();
    im.ImFontGlyphRangesBuilder_AddRanges(&builder, im.ImFontAtlas_GetGlyphRangesDefault(io.Fonts));
    im.ImFontGlyphRangesBuilder_AddRanges(&builder, im.ImFontAtlas_getGlyphRangesCyrillic(io.Fonts));

    var ranges = im.Vector(im.Wchar){};
    defer im.vectorDestruct(&ranges);

    im.ImFontGlyphRangesBuilder_BuildRanges(&builder, &ranges);

    const font = @embedFile("assets/nunito.ttf");
    im.ImFontAtlas_ClearFonts(io.Fonts);
    _ = im.ImFontAtlas_AddFontFromMemoryTTF(
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
