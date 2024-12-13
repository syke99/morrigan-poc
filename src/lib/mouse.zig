const std = @import("std");
const rl = @import("raylib");
const extism = @import("extism");

pub const MouseError = enum {
  AllocationError
};

pub const Mouse = struct {
    id: i32,
    button: Button,
    cursor: Cursor,
    
    pub fn init(self: *Mouse) error{MouseError}!i32 {
        // create UUID and set self.id equal
        _ = self;
        
        // store UUID and self in global allocator map

        // if error allocating Mouse, return MouseError.AllocationError
        
        // return UUID
        return 0;
    }
    
    pub fn deinit(self: *Mouse) void {
        // get UUID from self
        _ = self;
        
        // pass to global allocator to destory
    }

    pub fn button(b: []const u8) error{ButtonError}!Button {
        inline for (@typeInfo(Button).Enum.fields) |f| {
            if (std.mem.eql(u8, f.name, b)) {
                return @enumFromInt(f.value);
            }
        }
        return ButtonError.DoesntExist;
    }
};

pub const ButtonError = enum {
    DoesntExist,
};

pub const Button = enum {
    left,
    right,
    middle,
    side,
    extra,
    forward,
    back,

    // ========== RAYLIB FUNCTION WRAPPERS ==========
    
    pub fn isDown(self: *Button) bool {
        return rl.isButtonDown(getRaylibButton(self));
    }

    pub fn isUp(self: *Button) bool {
        return rl.isButtonUp(getRaylibButton(self));
    }

    pub fn isPressed(self: *Button) bool {
        return rl.isButtonPressed(getRaylibButton(self));
    }

    pub fn isReleased(self: *Button) bool {
        return rl.isButtonReleased(getRaylibButton(self));
    }
};

fn getButtonFromRaylibButton(rlb: rl.MouseButton) Button {
    const mouse_button = switch (rlb) {
        .mouse_button_left => Button.left,
        .mouse_button_right => Button.right,
        .mouse_button_middle => Button.middle,
        .mouse_button_side => Button.side,
        .mouse_button_extra => Button.extra,
        .mouse_button_forward => Button.forward,
        .mouse_button_back => Button.back
    };

    return mouse_button;
}

fn getRaylibButton(mb: Button) rl.MouseButton {
    const mouse_button = switch (mb) {
        .left => rl.MouseButton.mouse_button_left,
        .right => rl.MouseButton.mouse_button_right,
        .middle => rl.MouseButton.mouse_button_middle,
        .side => rl.MouseButton.mouse_button_side,
        .extra => rl.MouseButton.mouse_button_extra,
        .forward => rl.MouseButton.mouse_button_forward,
        .back => rl.MouseButton.mouse_button_back,
    };

    return mouse_button;
}

pub const Cursor = enum {
    default,
    arrow,
    ibeam,
    crosshair,
    pointing_hand,
    resize_ew,
    resize_ns,
    resize_nwse,
    resize_nesw,
    resize_all,
    not_allowed,

    // ========== RAYLIB FUNCTION WRAPPERS ==========

    pub fn set(self: *Cursor) void {
        rl.setCursor(getRaylibCursor(self));
    }
};

fn getRaylibCursor(mc: Cursor) rl.Cursor {
    const mouse_cursor = switch (mc) {
        .default => rl.Cursor.mouse_cursor_default,
        .arrow => rl.Cursor.mouse_cursor_arrow,
        .ibeam => rl.Cursor.mouse_cursor_ibeam,
        .crosshair => rl.Cursor.mouse_cursor_crosshair,
        .pointing_hand => rl.Cursor.mouse_cursor_pointing_hand,
        .resize_ew => rl.Cursor.mouse_cursor_resize_ew,
        .resize_ns => rl.Cursor.mouse_cursor_resize_ns,
        .resize_nwse => rl.Cursor.mouse_cursor_resize_nwse,
        .resize_nesw => rl.Cursor.mouse_cursor_resize_nesw,
        .resize_all => rl.Cursor.mouse_cursor_resize_all,
        .not_allowed => rl.Cursor.mouse_cursor_not_allowed,
    };

    return mouse_cursor;
}

// ========= INJECTED HOST FUNCTION(S) =========

// TODO: init/deinit functions for Mouse once global allocator is built

pub export fn host_isButtonUp(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = outputs;
    _ = n_outputs;
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const mouse_button_str = curr_plugin.inputBytes(&input_slice[0]);

    const host_mouse_button = std.meta.stringToEnum(Button, mouse_button_str);

    // handle setting/returning error on undefined host_key here

    // result
    _ = host_mouse_button.?.isUp();

    // return result here
    // curr_plugin.returnBytes(val: *c.ExtismVal, data: []const u8)
}

pub export fn host_isButtonDown(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = outputs;
    _ = n_outputs;
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const mouse_button_str = curr_plugin.inputBytes(&input_slice[0]);

    const host_mouse_button = std.meta.stringToEnum(Button, mouse_button_str);

    // handle setting/returning error on undefined host_key here

    // result
    _ = host_mouse_button.?.isDown();

    // return result here
    // curr_plugin.returnBytes(val: *c.ExtismVal, data: []const u8)
}

pub export fn host_isButtonPressed(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = outputs;
    _ = n_outputs;
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const mouse_button_str = curr_plugin.inputBytes(&input_slice[0]);

    const host_mouse_button = std.meta.stringToEnum(Button, mouse_button_str);

    // handle setting/returning error on undefined host_key here

    // result
    _ = host_mouse_button.?.isPressed();

    // return result here
    // curr_plugin.returnBytes(val: *c.ExtismVal, data: []const u8)
}

pub export fn host_isButtonReleased(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = outputs;
    _ = n_outputs;
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const mouse_button_str = curr_plugin.inputBytes(&input_slice[0]);

    const host_mouse_button = std.meta.stringToEnum(Button, mouse_button_str);

    // handle setting/returning error on undefined host_key here

    // result
    _ = host_mouse_button.?.isReleased();

    // return result here
    // curr_plugin.returnBytes(val: *c.ExtismVal, data: []const u8)
}

pub export fn host_setCursor(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = outputs;
    _ = n_outputs;
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const mouse_cursor_str = curr_plugin.inputBytes(&input_slice[0]);

    const host_mouse_cursor = std.meta.stringToEnum(Cursor, mouse_cursor_str);

    // handle setting/returning error on undefined host_key here

    // result
    _ = host_mouse_cursor.?.set();

    // return result here
    // curr_plugin.returnBytes(val: *c.ExtismVal, data: []const u8)
}

pub export fn host_getMouseX(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = inputs;
    _ = n_inputs;
    _ = outputs;
    _ = n_outputs;
    _ = user_data;

    // curr_plugin
    _ = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    // result
    _ = rl.getMouseX();

    // return result here
    // curr_plugin.returnBytes(val: *c.ExtismVal, data: []const u8)
}

pub export fn host_getMouseY(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = inputs;
    _ = n_inputs;
    _ = outputs;
    _ = n_outputs;
    _ = user_data;

    // curr_plugin
    _ = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    // result
    _ = rl.getMouseY();

    // return result here
    // curr_plugin.returnBytes(val: *c.ExtismVal, data: []const u8)
}

pub export fn host_getMouseWheelMove(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = inputs;
    _ = n_inputs;
    _ = outputs;
    _ = n_outputs;
    _ = user_data;

    // curr_plugin
    _ = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    // result
    _ = rl.getMouseWheelMove();

    // return result here
    // curr_plugin.returnBytes(val: *c.ExtismVal, data: []const u8)
}

// Vector2 values will need to be stored in
// a k/v store that stores a pointer to
// the Vector2 with the key being a UUID
// that can get passed back to the Go side
// to chain together calls if/when necessary:
//
// rl.getMouseMoveV()
//
// rl.getMouseDelta()
//
// rl.getMousePosition()
