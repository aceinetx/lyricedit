const std = @import("std");

const LyricStorage = @This();

pub const LyricLine = struct {
    id: usize,
    time: f32 = 0.0,
    text: [256]u8 = @splat(0),
};

allocator: std.mem.Allocator,
lyrics: std.ArrayList(LyricLine) = .empty,
next_lyric_id: usize = 0,

pub fn init(allocator: std.mem.Allocator) LyricStorage {
    return .{
        .allocator = allocator,
    };
}

pub fn deinit(self: *LyricStorage) void {
    self.lyrics.deinit(self.allocator);
}

pub fn addLine(self: *LyricStorage, line: LyricLine) !void {
    var new_line = line;
    new_line.id = self.next_lyric_id;
    try self.lyrics.append(self.allocator, new_line);
    self.next_lyric_id += 1;
}
