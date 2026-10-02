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

pub fn messageBox(title: [:0]const u8, message: [:0]const u8, dialog_type: DialogType, icon_type: IconType, default_button: i32) i32 {
    return tfd.tinyfd_messageBox(title, message, dialog_type.toString(), icon_type.toString(), default_button);
}
