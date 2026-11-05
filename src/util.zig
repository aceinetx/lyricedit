const std = @import("std");
const rl = @import("raylib");

pub fn rlIsAudioBufferPaused(buffer: *const rl.rAudioBuffer) bool {
    const paused: [*]const bool = @ptrCast(buffer);
    const offset = 357;
    return (paused + offset)[0];
}
