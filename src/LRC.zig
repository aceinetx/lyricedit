const std = @import("std");
const LyricStorage = @import("LyricStorage.zig");

const LRC = @This();

pub const DeserializeError = error{
    InvalidSyntax,
} || std.Io.Reader.Error || std.Io.Reader.StreamDelimiterLimitError || std.fmt.ParseIntError || std.mem.Allocator.Error;

const lrc_tags: []const struct { []const u8, []const u8 } = &.{
    .{ "ti", "song_title" },
    .{ "ar", "artist" },
    .{ "al", "album" },
    .{ "au", "author" },
    .{ "lr", "lyricist" },
    .{ "by", "lrc_author" },
    .{ "re", "program" },
};

allocator: std.mem.Allocator,
song_title: [256]u8 = @splat(0),
artist: [256]u8 = @splat(0),
album: [256]u8 = @splat(0),
author: [256]u8 = @splat(0),
lyricist: [256]u8 = @splat(0),
lrc_author: [256]u8 = @splat(0),
program: [256]u8 = @splat(0),

lyrics: LyricStorage,

pub fn init(allocator: std.mem.Allocator) LRC {
    return LRC{
        .allocator = allocator,
        .lyrics = .init(allocator),
    };
}

pub fn deinit(self: *LRC) void {
    self.lyrics.deinit();
}

fn deserialize_tag_value(reader: *std.Io.Reader) DeserializeError![]const u8 {
    if (try reader.takeByte() != ':') return DeserializeError.InvalidSyntax;
    const val = try reader.takeDelimiter(']') orelse return DeserializeError.InvalidSyntax;
    return val;
}

pub fn deserialize(reader: *std.Io.Reader, allocator: std.mem.Allocator) DeserializeError!LRC {
    var self = LRC.init(allocator);

    while ((try reader.takeDelimiter('[')) != null) {
        const first_two = try reader.takeArray(2);

        var is_tag = false;

        inline for (comptime lrc_tags) |tag| {
            if (std.mem.eql(u8, first_two, tag.@"0") and !is_tag) {
                var field = &@field(self, tag.@"1");

                const val = try deserialize_tag_value(reader);
                @memcpy(field[0..val.len], val);

                std.log.debug("{s} {s} {s}", .{ first_two, tag.@"1", field });

                is_tag = true;
            }
        }

        if (!is_tag) {
            const minutes: f32 = @floatFromInt(try std.fmt.parseInt(u8, first_two, 10));
            if (try reader.takeByte() != ':') return DeserializeError.InvalidSyntax;
            const seconds: f32 = @floatFromInt(try std.fmt.parseInt(u8, try reader.takeArray(2), 10));
            if (try reader.takeByte() != '.') return DeserializeError.InvalidSyntax;
            const milliseconds: f32 = @floatFromInt(try std.fmt.parseInt(u8, try reader.takeArray(2), 10));
            if (try reader.takeByte() != ']') return DeserializeError.InvalidSyntax;

            const time: f32 = (minutes * 60.0) + seconds + (milliseconds * 0.01);

            const text = try reader.takeDelimiter('\n') orelse return DeserializeError.InvalidSyntax;

            var lyric = LyricStorage.LyricLine{
                .id = undefined,
                .time = time,
                .text = undefined,
            };

            @memcpy(lyric.text[0..text.len], text);

            try self.lyrics.addLine(lyric);
        } else {
            _ = try reader.takeDelimiter('\n');
        }
    }

    return self;
}

pub fn serialize(self: *LRC, writer: *std.Io.Writer) !void {
    self.lyrics.sort();

    inline for (comptime lrc_tags) |tag| {
        const field = @field(self, tag.@"1");
        try writer.print("[{s}:{s}]\n", .{ tag.@"0", field });
    }

    for (self.lyrics.items()) |lyric| {
        const total_ms: u64 = @intFromFloat(lyric.time * 1000 + 0.5);
        const minutes: u64 = @divTrunc(total_ms, 60000);
        const seconds: u64 = @mod(@divTrunc(total_ms, 1000), 60);
        const milliseconds: u64 = @divTrunc(@mod(total_ms, 1000), 10);
        try writer.print("[{d:0>2}:{d:0>2}.{d:0>2}]{s}\n", .{ minutes, seconds, milliseconds, lyric.text });
    }
}
