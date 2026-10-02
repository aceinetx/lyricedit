const dcim = @import("imgui");
const std = @import("std");

pub const rl = struct {
    const rlim = @import("rlImGui");

    pub const setup = rlim.rlImGuiSetup;
    pub const shutdown = rlim.rlImGuiShutdown;

    pub const begin = rlim.rlImGuiBegin;
    pub const end = rlim.rlImGuiEnd;
};

pub const Io = dcim.ImGuiIO;
pub const getIo = dcim.ImGui_GetIO;

pub const ImFontAtlas = dcim.ImFontAtlas;
pub const ImFontConfig = dcim.ImFontConfig;

pub const ImFontConfig_default = ImFontConfig{
    .FontDataOwnedByAtlas = true,
    .OversampleH = 0,
    .OversampleV = 0,
    .GlyphMaxAdvanceX = std.math.floatMax(f32),
    .RasterizerMultiply = 1.0,
    .RasterizerDensity = 1.0,
    .EllipsisChar = 0,
};

pub const ImFontAtlas_ClearFonts = dcim.ImFontAtlas_ClearFonts;
pub const ImFontAtlas_AddFontFromMemoryTTF = dcim.ImFontAtlas_AddFontFromMemoryTTF;
pub const ImFontAtlas_GetGlyphRangesDefault = dcim.ImFontAtlas_GetGlyphRangesDefault;

pub const begin = dcim.ImGui_Begin;
pub const end = dcim.ImGui_End;
pub const showDemoWindow = dcim.ImGui_ShowDemoWindow;
