const std = @import("std");
const LRC = @import("LRC.zig");
const Tabs = @import("Tabs.zig");
const LyricStorage = @import("LyricStorage.zig");
const rl = @import("raylib");
const tfd = @import("tinyfiledialogs");
const im = @import("imgui");
const setup = @import("setup.zig");
const util = @import("util.zig");

var tabs: Tabs = undefined;

// ----------------------------------------------------------

fn draw_tab_bar() void {
    var remove_tab_id: ?usize = null;

    for (0.., tabs.tabs.items) |i, *tab| {
        if (i > 0)
            im.sameLine();

        const clicked_open = im.button(&tab.title);
        im.sameLine();
        const clicked_close = im.button(blk: {
            var label: [16:0]u8 = @splat(0);
            _ = std.fmt.bufPrint(&label, "x##{}", .{i}) catch unreachable;
            break :blk &label;
        });

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

// ----------------------------------------------------------

pub fn main(init: std.process.Init) void {
    tabs = .init(init.gpa);
    defer tabs.deinit();

    rl.initWindow(1280, 720, "lyricedit");
    defer rl.closeWindow();
    rl.initAudioDevice();

    rl.setWindowState(.{ .window_resizable = true });

    im.rl.setup(true);
    defer im.rl.shutdown();

    const io: *im.Io = im.getIo();

    setup.setupImGui();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);

        im.rl.begin();

        if (im.beginMainMenuBar()) {
            defer im.endMainMenuBar();

            if (im.beginMenu("File")) {
                defer im.endMenu();

                if (im.menuItem("New tab")) {
                    tabs.addTab() catch {};
                }

                if (tabs.current) |current| {
                    var tab = &tabs.tabs.items[current];

                    if (im.menuItem("Open song")) {
                        const file = tfd.openFileDialogSentinel(
                            "Open song",
                            null,
                            &.{"*.mp3"},
                            "Audio songs",
                            false,
                        );

                        if (rl.loadMusicStream(file)) |song| {
                            tab.setSong(song);
                        } else |e| {
                            std.log.err("Error loading song: {}", .{e});
                        }
                    }
                    if (im.menuItem("Open LRC")) {}
                }
            }
        }

        im.setNextWindowPos(.{
            .x = 0,
            .y = 24,
        }, 0);
        im.setNextWindowSize(.{
            .x = io.DisplaySize.x,
            .y = io.DisplaySize.y - 24,
        }, 0);
        if (im.begin(
            "Editor",
            null,
            im.WindowFlags.no_title_bar | im.WindowFlags.always_auto_resize | im.WindowFlags.no_resize | im.WindowFlags.no_move,
        )) {
            defer im.end();

            draw_tab_bar();

            if (tabs.current) |current| {
                tabs.tabs.items[current].draw();
            } else {}
        }

        im.rl.end();
    }
}
