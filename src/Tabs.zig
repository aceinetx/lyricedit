const std = @import("std");
const Tab = @import("Tab.zig");

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
