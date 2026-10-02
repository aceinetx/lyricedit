const rl = @import("raylib");
const tfd = @import("tinyfiledialogs");
const im = @import("imgui");

pub fn main() void {
    rl.initWindow(1280, 720, "lyricedit");
    defer rl.closeWindow();

    im.rl.setup(true);
    defer im.rl.shutdown();

    const io: *im.Io = im.getIo();
    io.IniFilename = null;

    var open = false;

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        rl.clearBackground(.black);

        im.rl.begin();
        im.showDemoWindow(&open);
        im.rl.end();

        rl.endDrawing();
    }
}
