const std = @import("std");
const tfd = @import("tinyfiledialogs");

pub const DialogType = enum {
    ok,
    okcancel,
    yesno,
    yesnocancel,

    pub fn toString(self: @This()) [*c]const u8 {
        return switch (self) {
            .ok => "ok",
            .okcancel => "okcancel",
            .yesno => "yesno",
            .yesnocancel => "yesnocancel",
        };
    }
};

pub const IconType = enum {
    info,
    warning,
    err,
    question,

    pub fn toString(self: @This()) [*c]const u8 {
        return switch (self) {
            .info => "info",
            .warning => "warning",
            .err => "err",
            .question => "question",
        };
    }
};

pub fn messageBox(
    title: [:0]const u8,
    message: [:0]const u8,
    dialog_type: DialogType,
    icon_type: IconType,
    default_button: i32,
) i32 {
    return tfd.tinyfd_messageBox(
        title,
        message,
        dialog_type.toString(),
        icon_type.toString(),
        default_button,
    );
}

pub fn openFileDialogSentinel(
    title: [:0]const u8,
    default_path_or_file: ?[:0]const u8,
    filter_patterns: []const [:0]const u8,
    single_filter_description: [:0]const u8,
    allow_multiple_selects: bool,
) [:0]const u8 {
    const file: [*:0]const u8 = tfd.tinyfd_openFileDialog(
        title,
        default_path_or_file orelse null,
        @intCast(filter_patterns.len),
        @ptrCast(filter_patterns.ptr),
        single_filter_description,
        @intFromBool(allow_multiple_selects),
    );
    const len = std.mem.len(file);
    return file[0..len :0];
}

pub fn openFileDialog(
    title: [:0]const u8,
    default_path_or_file: ?[:0]const u8,
    filter_patterns: []const [:0]const u8,
    single_filter_description: [:0]const u8,
    allow_multiple_selects: bool,
) []const u8 {
    const file: [*:0]const u8 = openFileDialogSentinel(
        title,
        default_path_or_file,
        filter_patterns,
        single_filter_description,
        allow_multiple_selects,
    );
    const len = std.mem.len(file);
    return file[0..len];
}

pub fn saveFileDialogSentinel(
    title: [:0]const u8,
    default_path_or_file: ?[:0]const u8,
    filter_patterns: []const [:0]const u8,
    single_filter_description: [:0]const u8,
) [:0]const u8 {
    const file: [*:0]const u8 = tfd.tinyfd_saveFileDialog(
        title,
        default_path_or_file orelse null,
        @intCast(filter_patterns.len),
        @ptrCast(filter_patterns.ptr),
        single_filter_description,
    );
    const len = std.mem.len(file);
    return file[0..len :0];
}

pub fn saveFileDialog(
    title: [:0]const u8,
    default_path_or_file: ?[:0]const u8,
    filter_patterns: []const [:0]const u8,
    single_filter_description: [:0]const u8,
) []const u8 {
    const file: [*:0]const u8 = saveFileDialogSentinel(
        title,
        default_path_or_file,
        filter_patterns,
        single_filter_description,
    );
    const len = std.mem.len(file);
    return file[0..len];
}
