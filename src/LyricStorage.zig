const std = @import("std");

const LyricStorage = @This();

pub const Segment = struct {
    id: usize,
    time: u64,
    text: [256]u8 = @splat(0),
};

pub const Line = struct {
    const Self = @This();

    id: usize,
    time: u64,
    segments: std.ArrayList(Segment),

    pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
        self.segments.deinit(allocator);
    }
};

allocator: std.mem.Allocator,
lyrics: std.ArrayList(Line) = .empty,
next_lyric_id: usize = 0,

pub fn init(allocator: std.mem.Allocator) LyricStorage {
    return .{
        .allocator = allocator,
    };
}

pub fn deinit(self: *LyricStorage) void {
    for (self.lyrics.items) |*line| {
        line.deinit(self.allocator);
    }

    self.lyrics.deinit(self.allocator);
}

fn sortPredicate(_: void, a: Line, b: Line) bool {
    return a.time < b.time;
}

pub fn sort(self: *LyricStorage) void {
    std.mem.sort(Line, self.lyrics.items, {}, sortPredicate);
}

pub fn addLine(self: *LyricStorage) *Line {
    try self.lyrics.append(self.allocator, std.mem.zeroes(Line));
    self.next_lyric_id += 1;
    self.sort();

    var line = &self.lyrics.items[self.lyrics.items.len - 1];
}

pub fn removeLineByIndex(self: *LyricStorage, index: usize) void {
    _ = self.lyrics.swapRemove(index);
}

pub fn items(self: *LyricStorage) []Line {
    return self.lyrics.items;
}
