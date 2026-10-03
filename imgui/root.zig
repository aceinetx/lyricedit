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
pub const separator = dcim.ImGui_Separator;

pub const SliderFlags = struct {
    pub const none: c_int = 0;
    pub const logarithmic: c_int = 1 << 5;
    pub const no_round_to_format: c_int = 1 << 6;
    pub const no_input: c_int = 1 << 7;
    pub const wrap_around: c_int = 1 << 8;
    pub const clamp_on_input: c_int = 1 << 9;
    pub const clamp_zero_range: c_int = 1 << 10;
    pub const no_speed_tweaks: c_int = 1 << 11;
};

pub const dragFloat = dcim.ImGui_DragFloat;
pub const dragFloatEx = dcim.ImGui_DragFloatEx;
pub const inputFloat = dcim.ImGui_InputFloat;

pub const pushItemWidth = dcim.ImGui_PushItemWidth;
pub const popItemWidth = dcim.ImGui_PopItemWidth;

pub const InputTextFlags = struct {
    pub const none: c_int = 0;
    pub const chars_decimal: c_int = 1 << 0;
    pub const chars_hexadecimal: c_int = 1 << 1;
    pub const chars_scientific: c_int = 1 << 2;
    pub const chars_uppercase: c_int = 1 << 3;
    pub const chars_no_blank: c_int = 1 << 4;
    pub const allow_tab_input: c_int = 1 << 5;
    pub const enter_returns_true: c_int = 1 << 6;
    pub const escape_clears_all: c_int = 1 << 7;
    pub const ctrl_enter_for_new_line: c_int = 1 << 8;
    pub const read_only: c_int = 1 << 9;
    pub const password: c_int = 1 << 10;
    pub const always_overwrite: c_int = 1 << 11;
    pub const auto_select_all: c_int = 1 << 12;
    pub const parse_empty_ref_val: c_int = 1 << 13;
    pub const display_empty_ref_val: c_int = 1 << 14;
    pub const no_horizontal_scroll: c_int = 1 << 15;
    pub const no_undo_redo: c_int = 1 << 16;
    pub const elide_left: c_int = 1 << 17;
    pub const callback_completion: c_int = 1 << 18;
    pub const callback_history: c_int = 1 << 19;
    pub const callback_always: c_int = 1 << 20;
    pub const callback_char_filter: c_int = 1 << 21;
    pub const callback_resize: c_int = 1 << 22;
    pub const callback_edit: c_int = 1 << 23;
};

pub const inputText = dcim.ImGui_InputText;

pub const TableColumnFlags = struct {
    pub const none: c_int = 0;
    pub const disabled: c_int = 1 << 0;
    pub const default_hide: c_int = 1 << 1;
    pub const default_sort: c_int = 1 << 2;
    pub const width_stretch: c_int = 1 << 3;
    pub const width_fixed: c_int = 1 << 4;
    pub const no_resize: c_int = 1 << 5;
    pub const no_reorder: c_int = 1 << 6;
    pub const no_hide: c_int = 1 << 7;
    pub const no_clip: c_int = 1 << 8;
    pub const no_sort: c_int = 1 << 9;
    pub const no_sort_ascending: c_int = 1 << 10;
    pub const no_sort_descending: c_int = 1 << 11;
    pub const no_header_label: c_int = 1 << 12;
    pub const no_header_width: c_int = 1 << 13;
    pub const prefer_sort_ascending: c_int = 1 << 14;
    pub const prefer_sort_descending: c_int = 1 << 15;
    pub const indent_enable: c_int = 1 << 16;
    pub const indent_disable: c_int = 1 << 17;
    pub const angled_header: c_int = 1 << 18;
    pub const is_enabled: c_int = 1 << 24;
    pub const is_visible: c_int = 1 << 25;
    pub const is_sorted: c_int = 1 << 26;
    pub const is_hovered: c_int = 1 << 27;
};

pub const beginTable = dcim.ImGui_BeginTable;
pub const endTable = dcim.ImGui_EndTable;
pub const tableNextRow = dcim.ImGui_TableNextRow;
pub const tableNextColumn = dcim.ImGui_TableNextColumn;
pub const setupColumn = dcim.ImGui_TableSetupColumn;

pub const beginGroup = dcim.ImGui_BeginGroup;
pub const endGroup = dcim.ImGui_EndGroup;

pub const Color = struct {
    pub const text = dcim.ImGuiCol_Text;
    pub const text_disabled = dcim.ImGuiCol_TextDisabled;
    pub const window_bg = dcim.ImGuiCol_WindowBg;
    pub const child_bg = dcim.ImGuiCol_ChildBg;
    pub const popup_bg = dcim.ImGuiCol_PopupBg;
    pub const border = dcim.ImGuiCol_Border;
    pub const border_shadow = dcim.ImGuiCol_BorderShadow;
    pub const frame_bg = dcim.ImGuiCol_FrameBg;
    pub const frame_bg_hovered = dcim.ImGuiCol_FrameBgHovered;
    pub const frame_bg_active = dcim.ImGuiCol_FrameBgActive;
    pub const title_bg = dcim.ImGuiCol_TitleBg;
    pub const title_bg_active = dcim.ImGuiCol_TitleBgActive;
    pub const title_bg_collapsed = dcim.ImGuiCol_TitleBgCollapsed;
    pub const menu_bar_bg = dcim.ImGuiCol_MenuBarBg;
    pub const scrollbar_bg = dcim.ImGuiCol_ScrollbarBg;
    pub const scrollbar_grab = dcim.ImGuiCol_ScrollbarGrab;
    pub const scrollbar_grab_hovered = dcim.ImGuiCol_ScrollbarGrabHovered;
    pub const scrollbar_grab_active = dcim.ImGuiCol_ScrollbarGrabActive;
    pub const check_mark = dcim.ImGuiCol_CheckMark;
    pub const slider_grab = dcim.ImGuiCol_SliderGrab;
    pub const slider_grab_active = dcim.ImGuiCol_SliderGrabActive;
    pub const button = dcim.ImGuiCol_Button;
    pub const button_hovered = dcim.ImGuiCol_ButtonHovered;
    pub const button_active = dcim.ImGuiCol_ButtonActive;
    pub const header = dcim.ImGuiCol_Header;
    pub const header_hovered = dcim.ImGuiCol_HeaderHovered;
    pub const header_active = dcim.ImGuiCol_HeaderActive;
    pub const separator = dcim.ImGuiCol_Separator;
    pub const separator_hovered = dcim.ImGuiCol_SeparatorHovered;
    pub const separator_active = dcim.ImGuiCol_SeparatorActive;
    pub const resize_grip = dcim.ImGuiCol_ResizeGrip;
    pub const resize_grip_hovered = dcim.ImGuiCol_ResizeGripHovered;
    pub const resize_grip_active = dcim.ImGuiCol_ResizeGripActive;
    pub const input_text_cursor = dcim.ImGuiCol_InputTextCursor;
    pub const tab_hovered = dcim.ImGuiCol_TabHovered;
    pub const tab = dcim.ImGuiCol_Tab;
    pub const tab_selected = dcim.ImGuiCol_TabSelected;
    pub const tab_selected_overline = dcim.ImGuiCol_TabSelectedOverline;
    pub const tab_dimmed = dcim.ImGuiCol_TabDimmed;
    pub const tab_dimmed_selected = dcim.ImGuiCol_TabDimmedSelected;
    pub const tab_dimmed_selected_overline = dcim.ImGuiCol_TabDimmedSelectedOverline;
    pub const plot_lines = dcim.ImGuiCol_PlotLines;
    pub const plot_lines_hovered = dcim.ImGuiCol_PlotLinesHovered;
    pub const plot_histogram = dcim.ImGuiCol_PlotHistogram;
    pub const plot_histogram_hovered = dcim.ImGuiCol_PlotHistogramHovered;
    pub const table_header_bg = dcim.ImGuiCol_TableHeaderBg;
    pub const table_border_strong = dcim.ImGuiCol_TableBorderStrong;
    pub const table_border_light = dcim.ImGuiCol_TableBorderLight;
    pub const table_row_bg = dcim.ImGuiCol_TableRowBg;
    pub const table_row_bg_alt = dcim.ImGuiCol_TableRowBgAlt;
    pub const text_link = dcim.ImGuiCol_TextLink;
    pub const text_selected_bg = dcim.ImGuiCol_TextSelectedBg;
    pub const tree_lines = dcim.ImGuiCol_TreeLines;
    pub const drag_drop_target = dcim.ImGuiCol_DragDropTarget;
    pub const nav_cursor = dcim.ImGuiCol_NavCursor;
    pub const nav_windowing_highlight = dcim.ImGuiCol_NavWindowingHighlight;
    pub const nav_windowing_dim_bg = dcim.ImGuiCol_NavWindowingDimBg;
    pub const modal_window_dim_bg = dcim.ImGuiCol_ModalWindowDimBg;
};

pub const pushStyleColorImVec4 = dcim.ImGui_PushStyleColorImVec4;
pub const popStyleColor = dcim.ImGui_PopStyleColor;
pub const pushStyleVar = dcim.ImGui_PushStyleVar;
pub const pushStyleVarImVec2 = dcim.ImGui_PushStyleVarImVec2;
pub const popStyleVar = dcim.ImGui_PopStyleVar;
