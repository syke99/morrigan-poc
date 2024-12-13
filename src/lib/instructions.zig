const rl = @import("raylib");

const libcolor = @import("color.zig");

pub const Instruction = union {
    Text: Text,
};

pub const Text = struct {
    text: []const u8,
    posX: i32,
    posY: i32,
    fontSize: i32,
    textColor: []const u8,

    fn draw(self: *Text) !void {
        rl.drawText(
            self.text,
            self.posX,
            self.posY,
            self.fontSize,
            libcolor.Color.initByName(self.textColor)
        );
    }
};
