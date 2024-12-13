const std = @import("std");
const rl = @import("raylib");
const extism = @import("extism");

const libcolor = @import("color.zig");
const libdraw = @import("draw.zig");
const Instruction = @import("instructions.zig").Instruction;

const Window = struct {
    width: i32,
    height: i32,
    targetFPS: ?i32,
    title: []const u8,
    backgroundColor: []const u8,
    initialInstructions: ?[]Instruction,

    pub fn init(self: *Window) !void {
        rl.initWindow(
            self.width,
            self.height,
            self.title
        );

        while (!rl.windowShouldClose()) {
            rl.beginDrawing();

            const background_color = try libcolor.Color.initByName(self.backgroundColor) catch libcolor.ColorError.DoesntExist;

            rl.clearBackground(background_color);

            if (self.targetFPS != null) {
                rl.setTargetFPS(self.targetFPS.?);
            }

            if (self.initialInstructions != null) {
                inline for (self.initialInstructions.?) |value| {
                    libdraw.draw(value);
                }
            }

            // one thread here for handling main loop
            //
            // another thread here for monitoring key state
            //
            // another thread here for monitoring mouse state
            //
            // another thread here for monitoring audio state
            //
            // etc.
            //
            // etc.

            rl.endDrawing();
        }

        rl.closeWindow();
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

pub fn initWindow(windowStr: [*:0]const u8) !void {
    const window = unmarshalWindow(windowStr);

    try window.init();
}

// ========= INJECTED HOST FUNCTION(S) =========

pub export fn host_initWindow(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = outputs;
    _ = n_outputs;
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    // retrieve the key from the plugin
    var input_slice = inputs[0..n_inputs];
    const windowStr = curr_plugin.inputBytes(&input_slice[0]);

    try initWindow(windowStr);
}

