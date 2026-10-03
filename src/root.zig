const std = @import("std");
const LRC = @import("LRC.zig");
const Tabs = @import("Tabs.zig");
const LyricStorage = @import("LyricStorage.zig");
const rl = @import("raylib");
const tfd = @import("tinyfiledialogs");
const im = @import("imgui");
const setup = @import("setup.zig");
const util = @import("util.zig");

// ----------------------------------------------------------

var tabs: Tabs = undefined;
var quit: bool = false;

// ----------------------------------------------------------

fn drawTabBar(arena: std.mem.Allocator) void {
    var remove_tab_id: ?usize = null;

    for (0.., tabs.tabs.items) |i, *tab| {
        if (i > 0)
            im.sameLine();

        const clicked_open = im.button(im.uniqueId(arena, &tab.title, "tab", i));
        im.sameLine();
        const clicked_close = im.button(im.uniqueId(arena, "x", "close", i));

        if (clicked_open) {
            tabs.current = i;
        }

        if (clicked_close) {
            remove_tab_id = i;
        }
    }

    if (remove_tab_id) |id| {
        tabs.removeTab(id);
    }
}

fn drawMenuBar(io: std.Io) void {
    if (im.beginMainMenuBar()) {
        defer im.endMainMenuBar();

        if (im.beginMenu("File")) {
            defer im.endMenu();

            if (im.menuItem("New tab")) {
                tabs.addTab() catch {};
            }

            if (tabs.current) |current| {
                im.separator();

                var tab = &tabs.tabs.items[current];

                if (im.menuItem("Open song")) {
                    if (tfd.openFileDialogSentinel(
                        "Open song",
                        null,
                        &.{"*.mp3"},
                        "Audio songs",
                        false,
                    )) |path| {
                        if (rl.loadMusicStream(path)) |song| {
                            tab.setSong(song);
                        } else |e| {
                            std.log.err("Error loading song: {}", .{e});
                        }
                    }
                }

                if (im.menuItem("Open LRC")) {
                    if (tfd.openFileDialog(
                        "Open lyrics file",
                        null,
                        &.{"*.lrc"},
                        "Lyrics file",
                        false,
                    )) |path| {
                        tab.loadLRCFromPath(io, path) catch |e| {
                            std.log.err("Failed to load LRC: {}", .{e});
                        };
                    }
                }

                im.separator();

                if (im.menuItem("Save LRC")) {
                    if (tfd.saveFileDialog(
                        "Save lyrics file",
                        null,
                        &.{"*.lrc"},
                        "Lyrics file",
                    )) |path| {
                        tab.saveLRC(io, path) catch |e| {
                            std.log.err("Failed to save LRC: {}", .{e});
                        };
                    }
                }
            }

            im.separator();
            if (im.menuItem("Quit")) {
                quit = true;
            }
        }

        if (tabs.current) |current| {
            const tab = &tabs.tabs.items[current];
            if (im.beginMenu("Tab")) {
                defer im.endMenu();

                _ = im.inputText("Tab title", &tab.title, tab.title.len, 0);

                const fields: [7]struct { []const u8, []u8 } = .{
                    .{ "Song title", &tab.lrc.song_title },
                    .{ "Artist", &tab.lrc.artist },
                    .{ "Album", &tab.lrc.album },
                    .{ "Author", &tab.lrc.author },
                    .{ "Lyricist", &tab.lrc.lyricist },
                    .{ "LRC Author", &tab.lrc.lrc_author },
                    .{ "Program", &tab.lrc.program },
                };

                for (fields) |field| {
                    _ = im.inputText(field.@"0".ptr, field.@"1".ptr, field.@"1".len, 0);
                }
            }
        }
    }
}

// ----------------------------------------------------------

pub fn main(init: std.process.Init) void {
    tabs = .init(init.gpa);
    defer tabs.deinit();

    rl.initWindow(1280, 720, "lyricedit");
    defer rl.closeWindow();
    rl.initAudioDevice();

    rl.setExitKey(.null);

    im.rl.setup(true);
    defer im.rl.shutdown();

    const io: *im.Io = im.getIo();

    setup.setupImGui();

    var frame_arena = std.heap.ArenaAllocator.init(init.gpa);
    defer frame_arena.deinit();

    while (!rl.windowShouldClose() and !quit) {
        _ = frame_arena.reset(.retain_capacity);

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);

        im.rl.begin();
        defer im.rl.end();

        // ----------------------------------------------------------
        drawMenuBar(init.io);

        im.setNextWindowPos(.{
            .x = 0,
            .y = 24,
        }, 0);
        im.setNextWindowSize(.{
            .x = io.DisplaySize.x,
            .y = 128,
        }, 0);
        if (im.begin(
            "Editor",
            null,
            im.WindowFlags.no_title_bar | im.WindowFlags.no_collapse | im.WindowFlags.always_auto_resize | im.WindowFlags.no_resize | im.WindowFlags.no_move | im.WindowFlags.no_collapse,
        )) {
            defer im.end();

            drawTabBar(frame_arena.allocator());

            if (tabs.current) |current| {
                tabs.tabs.items[current].draw_top();
            }

            im.setNextWindowPos(.{
                .x = im.getWindowPos().x,
                .y = im.getWindowPos().y + im.getWindowSize().y,
            }, 0);
            im.setNextWindowSize(.{
                .x = io.DisplaySize.x,
                .y = io.DisplaySize.y - im.getWindowSize().y - im.getWindowPos().y,
            }, 0);
            if (im.begin(
                "Workspace",
                null,
                im.WindowFlags.no_title_bar | im.WindowFlags.no_collapse | im.WindowFlags.always_auto_resize | im.WindowFlags.no_resize | im.WindowFlags.no_move | im.WindowFlags.no_collapse,
            )) {
                defer im.end();

                if (tabs.current) |current| {
                    tabs.tabs.items[current].draw_lyrics(frame_arena.allocator());
                }
            }
        }
    }
}
