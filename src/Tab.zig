const std = @import("std");
const LRC = @import("LRC.zig");
const LyricStorage = @import("LyricStorage.zig");
const rl = @import("raylib");
const im = @import("imgui");

allocator: std.mem.Allocator,
title: [255:0]u8 = @splat(0),
lrc: LRC,
song: ?rl.Music = null,
song_paused: bool = false,
song_volume: f32 = 1.0,

pub fn init(allocator: std.mem.Allocator) @This() {
    return .{
        .allocator = allocator,
        .lrc = LRC.init(allocator),
    };
}

pub fn setSong(self: *@This(), song: ?rl.Music) void {
    std.log.debug("song set", .{});
    if (self.song != null) {
        self.song.?.unload();
        std.log.debug("song unloaded", .{});
    }

    self.song = song;
}

pub fn deinit(self: *@This()) void {
    self.lrc.deinit();

    self.setSong(null);
}

pub fn draw(self: *@This()) void {
    if (self.song) |song| {
        rl.updateMusicStream(song);

        // ----------------------------------------------------------

        im.text("Time");

        im.sameLine();

        if (im.button(">")) {
            rl.playMusicStream(song);
        }
        im.sameLine();
        if (im.button("#")) {
            rl.stopMusicStream(song);
        }
        im.sameLine();
        const pause_button_label = if (self.song_paused)
            "|>"
        else
            "| |";

        if (im.button(pause_button_label)) {
            self.song_paused = !self.song_paused;
            if (self.song_paused)
                rl.pauseMusicStream(song)
            else
                rl.resumeMusicStream(song);
        }

        var time =
            rl.getMusicTimePlayed(song);

        const length =
            rl.getMusicTimeLength(song);

        im.sameLine();

        im.pushItemWidth(-1);
        if (im.dragFloatEx("##time", &time, 0.1, 0, length, null, 0)) {
            rl.seekMusicStream(song, time);
        }
        im.popItemWidth();

        // ----------------------------------------------------------

        im.text("Volume");

        im.sameLine();

        im.pushItemWidth(-1);
        if (im.dragFloatEx("##volume", &self.song_volume, 0, 0, 1, null, 0)) {
            rl.setMusicVolume(song, self.song_volume);
        }
        im.popItemWidth();
    }

    // ----------------------------------------------------------

    if (im.button("Add lyric line at current time")) {
        var lyric = LyricStorage.LyricLine{
            .id = undefined,
            .text = @splat(0),
            .time = if (self.song) |song|
                rl.getMusicTimePlayed(song)
            else
                0,
        };
        @memcpy(lyric.text[0..10], "Lyric line");
        self.lrc.lyrics.addLine(lyric) catch {};
    }

    // ----------------------------------------------------------
    for (self.lrc.lyrics.lyrics.items) |*lyric| {
        _ = im.inputText(blk: {
            var buf: [255:0]u8 = @splat(0);
            _ = std.fmt.bufPrint(&buf, "##{}", .{lyric.id}) catch unreachable;
            break :blk &buf;
        }, @ptrCast(&lyric.text), lyric.text.len, 0);
    }
}
