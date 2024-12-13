const Instruction = @import("instructions.zig").Instruction;

pub fn draw(instruction: Instruction) !void {
    switch (instruction) {
        .Text => |*t| t.draw()
        // additional instructions will go here
    }
}
