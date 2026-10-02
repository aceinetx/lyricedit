const dcim = @import("imgui");

pub const rl = struct {
    const rlim = @import("rlImGui");

    pub const setup = rlim.rlImGuiSetup;
    pub const shutdown = rlim.rlImGuiShutdown;

    pub const begin = rlim.rlImGuiBegin;
    pub const end = rlim.rlImGuiEnd;
};

pub const Io = dcim.ImGuiIO;
pub const getIo = dcim.ImGui_GetIO;

pub const begin = dcim.ImGui_Begin;
pub const end = dcim.ImGui_End;
pub const showDemoWindow = dcim.ImGui_ShowDemoWindow;
