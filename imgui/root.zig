pub const dcim = @import("imgui");
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

pub const WindowFlags = struct {
    pub const none: c_int = 0;
    pub const no_title_bar: c_int = 1 << 0;
    pub const no_resize: c_int = 1 << 1;
    pub const no_move: c_int = 1 << 2;
    pub const no_scrollbar: c_int = 1 << 3;
    pub const no_scroll_with_mouse: c_int = 1 << 4;
    pub const no_collapse: c_int = 1 << 5;
    pub const always_auto_resize: c_int = 1 << 6;
    pub const no_background: c_int = 1 << 7;
    pub const no_saved_settings: c_int = 1 << 8;
    pub const no_mouse_inputs: c_int = 1 << 9;
    pub const menu_bar: c_int = 1 << 10;
    pub const horizontal_Scrollbar: c_int = 1 << 11;
    pub const no_focus_on_appearing: c_int = 1 << 12;
    pub const no_bring_to_front_on_focus: c_int = 1 << 13;
    pub const always_vertical_scrollbar: c_int = 1 << 14;
    pub const always_horizontal_scrollbar: c_int = 1 << 15;
    pub const no_nav_inputs: c_int = 1 << 16;
    pub const no_nav_focus: c_int = 1 << 17;
    pub const unsaved_document: c_int = 1 << 18;
};

pub const Cond = struct {
    pub const none: c_int = 0;
    pub const always: c_int = 1 << 0;
    pub const once: c_int = 1 << 1;
    pub const first_use_ever: c_int = 1 << 2;
    pub const appearing: c_int = 1 << 3;
};

pub const begin = dcim.ImGui_Begin;
pub const end = dcim.ImGui_End;
pub const setNextWindowPos = dcim.ImGui_SetNextWindowPos;
pub const setNextWindowSize = dcim.ImGui_SetNextWindowSize;
pub const showDemoWindow = dcim.ImGui_ShowDemoWindow;

pub const beginMainMenuBar = dcim.ImGui_BeginMainMenuBar;
pub const endMainMenuBar = dcim.ImGui_EndMainMenuBar;
pub const beginMenu = dcim.ImGui_BeginMenu;
pub const endMenu = dcim.ImGui_EndMenu;
pub const menuItem = dcim.ImGui_MenuItem;

pub const TabBarFlags = struct {
    pub const none: c_int = 0;
    pub const reorderable: c_int = 1 << 0;
    pub const auto_select_new_tabs: c_int = 1 << 1;
    pub const tab_list_popup_button: c_int = 1 << 2;
    pub const no_close_with_middle_mouse_button: c_int = 1 << 3;
    pub const no_tab_list_scrolling_buttons: c_int = 1 << 4;
    pub const no_tooltip: c_int = 1 << 5;
    pub const draw_selected_overline: c_int = 1 << 6;
    pub const fitting_policy_mixed: c_int = 1 << 7;
    pub const fitting_policy_shrink: c_int = 1 << 8;
    pub const fitting_policy_scroll: c_int = 1 << 9;
};

pub const beginTabBar = dcim.ImGui_BeginTabBar;
pub const endTabBar = dcim.ImGui_EndTabBar;

pub const TabItemFlags = struct {
    pub const none: c_int = 0;
    pub const unsaved_document: c_int = 1 << 0;
    pub const set_selected: c_int = 1 << 1;
    pub const no_close_with_middle_mouse_button: c_int = 1 << 2;
    pub const no_push_id: c_int = 1 << 3;
    pub const no_tooltip: c_int = 1 << 4;
    pub const no_reorder: c_int = 1 << 5;
    pub const leading: c_int = 1 << 6;
    pub const trailing: c_int = 1 << 7;
    pub const no_assumed_closure: c_int = 1 << 8;
};

pub const beginTabItem = dcim.ImGui_BeginTabItem;
pub const endTabItem = dcim.ImGui_EndTabItem;

pub const text = dcim.ImGui_Text;
pub const button = dcim.ImGui_Button;
pub const sameLine = dcim.ImGui_SameLine;
