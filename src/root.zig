const std = @import("std");
const LRC = @import("LRC.zig");
const rl = @import("raylib");
const tfd = @import("tinyfiledialogs");
const im = @import("imgui");
const setup = @import("setup.zig");
const util = @import("util.zig");

const Tab = struct {
    allocator: std.mem.Allocator,
    title: [255:0]u8 = @splat(0),
    lrc: LRC,
    song: ?rl.Music = null,

    pub fn init(allocator: std.mem.Allocator) @This() {
        return .{
            .allocator = allocator,
            .lrc = LRC.init(),
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
        self.lrc.deinit(self.allocator);

        self.setSong(null);
    }

    pub fn draw(self: *@This()) void {
        _ = self;
    }
};

const Tabs = struct {
    const Self = @This();

    allocator: std.mem.Allocator,
    tabs: std.ArrayList(Tab) = .empty,
    next_tab_id: usize = 1,
    current: ?usize = null,

    pub fn init(allocator: std.mem.Allocator) Self {
        return .{
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Self) void {
        for (self.tabs.items) |*tab|
            tab.deinit();
        self.tabs.deinit(self.allocator);
    }

    inline fn invalidateCurrent(self: *Self) void {
        if (self.tabs.items.len == 0) {
            self.current = null;
        } else if (self.current == null) {
            self.current = self.tabs.items.len - 1;
        } else if (self.current.? >= self.tabs.items.len) {
            self.current = self.tabs.items.len - 1;
        }
    }

    pub inline fn addTab(self: *Self) !void {
        var tab = Tab.init(self.allocator);
        _ = try std.fmt.bufPrint(&tab.title, "Tab #{}", .{self.next_tab_id});
        self.next_tab_id += 1;

        try self.tabs.append(self.allocator, tab);

        self.current = self.tabs.items.len - 1;
        self.invalidateCurrent();
    }

    pub inline fn removeTab(self: *Self, index: usize) void {
        var tab = self.tabs.swapRemove(index);
        tab.deinit();
        self.invalidateCurrent();
    }
};

var tabs: Tabs = undefined;

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

fn draw_tab(id: usize) void {
    const tab = &tabs.tabs.items[id];

    if (im.button(">")) {
        if (tab.song) |song| {
            rl.playMusicStream(song);
        }
    }

    if (tab.song) |song| {
        rl.updateMusicStream(song);
        std.log.debug("{}", .{
            rl.getMusicTimePlayed(song),
        });
    }
}

pub fn main(init: std.process.Init) void {
    tabs = .init(init.gpa);
    defer tabs.deinit();

    rl.initWindow(1280, 720, "lyricedit");
    defer rl.closeWindow();
    rl.initAudioDevice();

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
                draw_tab(current);
            } else {}
        }

        im.rl.end();
    }
}
