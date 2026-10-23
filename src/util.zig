const std = @import("std");
const rl = @import("raylib");

pub fn rlIsAudioBufferPaused(buffer: *const rl.rAudioBuffer) bool {
    const offset = 357;
    const paused: *const bool = @ptrFromInt(@intFromPtr(buffer) + offset);
    std.debug.print("{}", .{@as(*u8, @ptrFromInt(@intFromPtr(buffer) + offset)).*});
    return paused.*;
}
