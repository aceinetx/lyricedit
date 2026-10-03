const std = @import("std");
const LRC = @import("LRC.zig");
const LyricStorage = @import("LyricStorage.zig");
const rl = @import("raylib");
const im = @import("imgui");

const Tab = @This();

allocator: std.mem.Allocator,
title: [256]u8 = @splat(0),
lrc: LRC,
song: ?rl.Music = null,
song_paused: bool = false,
song_volume: f32 = 1.0,

pub fn init(allocator: std.mem.Allocator) Tab {
    return .{
        .allocator = allocator,
        .lrc = LRC.init(allocator),
    };
}

pub fn deinit(self: *Tab) void {
    self.lrc.deinit();

    self.setSong(null);
}

pub fn setSong(self: *Tab, song: ?rl.Music) void {
    std.log.debug("song set", .{});
    if (self.song != null) {
        self.song.?.unload();
        std.log.debug("song unloaded", .{});
    }

    self.song = song;
}

pub fn loadLRC(self: *Tab, lrc: LRC) void {
    self.lrc.deinit();
    self.lrc = lrc;
    if (self.lrc.song_title[0] != 0) {
        @memcpy(&self.title, &self.lrc.song_title);
    }
}

pub fn loadLRCFromPath(self: *Tab, io: std.Io, path: []const u8) !void {
    const file = try std.Io.Dir.openFileAbsolute(io, path, .{});
    defer file.close(io);

    var buffer: [2048]u8 = undefined;
    var reader = file.reader(io, &buffer);

    self.loadLRC(try LRC.deserialize(&reader.interface, self.allocator));
}

pub fn saveLRC(self: *Tab, io: std.Io, path: []const u8) !void {
    const file = try std.Io.Dir.createFileAbsolute(io, path, .{});
    defer file.close(io);

    var buffer: [2048]u8 = undefined;
    var writer = file.writer(io, &buffer);

    try self.lrc.serialize(&writer.interface);

    try writer.flush();
}

pub fn draw_top(self: *Tab) void {
    im.beginGroup();
    defer im.endGroup();

    if (self.song) |song| {
        rl.updateMusicStream(song);

        // ----------------------------------------------------------

        if (im.beginTable("Song controls", 2, 0)) {
            defer im.endTable();

            im.setupColumn("Title", 0);
            im.setupColumn("Controls", im.TableColumnFlags.width_stretch);

            _ = im.tableNextRow();
            {
                _ = im.tableNextColumn();

                im.text("Time");

                _ = im.tableNextColumn();
                im.beginGroup();
                {
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
                }
                im.endGroup();
            }

            _ = im.tableNextRow();
            {
                _ = im.tableNextColumn();

                im.text("Volume");

                _ = im.tableNextColumn();

                im.pushItemWidth(-1);
                if (im.dragFloatEx("##volume", &self.song_volume, 0, 0, 1, null, 0)) {
                    rl.setMusicVolume(song, self.song_volume);
                }
                im.popItemWidth();
            }
        }
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
}

pub fn draw_lyrics(self: *Tab, arena: std.mem.Allocator) void {
    im.beginGroup();
    defer im.endGroup();

    var remove_lyric_index: ?usize = null;
    var do_sort: bool = false;

    const time_played = if (self.song) |song|
        rl.getMusicTimePlayed(song)
    else
        0;

    if (im.beginTable("lyrics", 3, 0)) {
        defer im.endTable();

        im.setupColumn(null, im.TableColumnFlags.width_stretch);
        im.setupColumn(null, 0);
        im.setupColumn(null, 0);

        var current_lyric_index: ?usize = null;
        for (0.., self.lrc.lyrics.items()) |i, lyric| {
            if (time_played >= lyric.time)
                current_lyric_index = i
            else
                break;
        }

        for (0.., self.lrc.lyrics.lyrics.items) |lyric_index, *lyric| {
            const is_current = (current_lyric_index != null and current_lyric_index.? == lyric_index);

            im.tableNextRow();

            _ = im.tableNextColumn();

            im.pushItemWidth(-1);
            if (!is_current) {
                im.pushStyleColorImVec4(im.Color.text, .{
                    .x = 0.7,
                    .y = 0.7,
                    .z = 0.7,
                    .w = 0.7,
                });
            }
            _ = im.inputText(
                im.uniqueId(arena, "", "line", lyric.id),
                @ptrCast(&lyric.text),
                lyric.text.len,
                0,
            );
            if (!is_current) {
                im.popStyleColor();
            }
            im.popItemWidth();

            _ = im.tableNextColumn();

            im.pushItemWidth(100.0);
            if (im.dragFloatEx(
                im.uniqueId(arena, "", "time", lyric.id),
                &lyric.time,
                0.1,
                0,
                -1,
                null,
                0,
            )) {
                do_sort = true;
            }
            im.popItemWidth();

            _ = im.tableNextColumn();

            im.pushItemWidth(100.0);
            if (im.button(
                im.uniqueId(arena, "remove", "remove_button", lyric.id),
            )) {
                remove_lyric_index = lyric_index;
            }
            im.popItemWidth();
        }
    }

    if (remove_lyric_index) |index| {
        self.lrc.lyrics.removeLineByIndex(index);
    }

    if (do_sort) {
        self.lrc.lyrics.sort();
    }
}
