const std = @import("std");
const rl = @import("raylib");

const libcolor = @import("color.zig");

const Window = struct {
    width: i32,
    height: i32,
    targetFPS: ?i32,
    title: [*:0]const u8,
    backgroundColor: libcolor.Color,
    initialInstructions: ?[]Instruction,

    pub fn draw(instruction: Instruction) !void {
        switch (instruction) {
            .Text => |*t| t.draw()
        }
    }

    pub fn init(self: *Window) !void {
        rl.initWindow(
            self.width,
            self.height,
            self.title
        );

        while (!rl.windowShouldClose()) {
            rl.beginDrawing();

            rl.clearBackground(self.backgroundColor.getColor());

            if (self.targetFPS != null) {
                rl.setTargetFPS(self.targetFPS.?);
            }

            if (self.initialInstructions != null) {
                inline for (self.initialInstructions.?) |value| {
                    self.draw(value);
                }
            }

            rl.endDrawing();
        }

        rl.closeWindow();
    }

};

pub const Instruction_T = enum {
  Text,
};

pub const Instruction = union(Instruction_T) {
    Text: Text,
};

const Text = struct {
    text: [*:0]const u8,
    posX: i32,
    posY: i32,
    fontSize: i32,
    textColor: libcolor.Color,

    fn getColor(self: *Text) rl.Color {
        return self.getColor();
    }

    fn draw(self: *Text) !void {
        rl.drawText(
            self.text,
            self.posX,
            self.posY,
            self.fontSize,
            self.getColor()
        );
    }
};

fn unmarshalWindow(windowStr: [*:0]const u8) Window {
    var jsonBuf: [windowStr.len]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&jsonBuf);

    var string = std.ArrayList(u8).init(fba.allocator());

    const parsed = try std.json.parseFromSlice(
        Window,
        fba,
        .{},
        string.writer()
    );
    defer parsed.deinit();

    return parsed.value;
}

pub fn makeWindow(windowStr: [*:0]const u8) !void {
    const window = unmarshalWindow(windowStr);

    try window.init();
}
