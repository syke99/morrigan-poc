const std = @import("std");
const rl = @import("raylib");
const extism = @import("extism");

const liballocator = @import("allocator.zig");

pub const MouseError = enum {
  AllocationError
};

pub const Mouse = struct {
    id: i32,
    button: Button,
    cursor: Cursor,
    
    pub fn init(self: *Mouse) error{MouseError}!i32 {
        _ = self;

        // TODO: catch alloc error
        const id = liballocator.allocate(Mouse);

        const self_ptr = liballocator.retrieve(Mouse, id);

        self_ptr.id = id;

        // if error allocating Mouse, return MouseError.AllocationError
        
        // return id
        return id;
    }
    
    pub fn deinit(self: *Mouse) void {
        liballocator.free(self.id);
    }

    pub fn button(b: []const u8) error{ButtonError}!Button {
        if (std.meta.stringToEnum(Button, b)) |btn| {
            return btn;
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

    const CursorTable = [@typeInfo(Cursor).Enum.fields.len][]const u8{
        "default",
        "arrow",
        "ibeam",
        "crosshair",
        "pointing_hand",
        "resize_ew",
        "resize_ns",
        "resize_nwse",
        "resize_nesw",
        "resize_all",
        "not_allowed",
    };

    pub fn get(name: []const u8) *Cursor {
        inline for (@typeInfo(Cursor).Enum.fields) |f| {
            if (std.mem.eql([]const u8, f.name, name)) {
                return @enumFromInt(f.value);
            }
        }
        return Cursor.default;
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

pub export fn host_mouse(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = inputs;
    _ = n_inputs;
    _ = user_data;

    // TODO: catch error
    const id = try Mouse.init();

    const curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var output_slice = outputs[0..n_outputs];

    var id_buf: [@sizeOf(i32)]u8 = undefined;

    std.fmt.formatIntBuf(&id_buf, id, 10, std.fmt.Case.lower, .{});

    curr_plugin.returnBytes(&output_slice[0], id_buf);
}

pub export fn host_freeMouse(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = outputs;
    _ = n_outputs;
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const id_str = curr_plugin.inputBytes(&input_slice[0]);

    const id = try std.fmt.parseInt(i32, id_str, 10);

    var mouse: *Mouse = @ptrFromInt(id);

    mouse.deinit();
}

pub export fn host_isButtonUp(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const mouse_button_str = curr_plugin.inputBytes(&input_slice[0]);

    const host_mouse_button = std.meta.stringToEnum(Button, mouse_button_str);

    // handle setting/returning error on undefined host_key here

    // result
    const result = host_mouse_button.?.isUp();

    var output_slice = outputs[0..n_outputs];

    var result_buff: []const u8 = undefined;

    if (result) {
        result_buff = "true";
    } else {
        result_buff = "false";
    }

    // return result here
    curr_plugin.returnBytes(&output_slice[0], result_buff);
}

pub export fn host_isButtonDown(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const mouse_button_str = curr_plugin.inputBytes(&input_slice[0]);

    const host_mouse_button = std.meta.stringToEnum(Button, mouse_button_str);

    // handle setting/returning error on undefined host_key here

    // result
    const result = host_mouse_button.?.isDown();

    var output_slice = outputs[0..n_outputs];

    var result_buff: []const u8 = undefined;

    if (result) {
        result_buff = "true";
    } else {
        result_buff = "false";
    }

    // return result here
    curr_plugin.returnBytes(&output_slice[0], result_buff);
}

pub export fn host_isButtonPressed(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const mouse_button_str = curr_plugin.inputBytes(&input_slice[0]);

    const host_mouse_button = std.meta.stringToEnum(Button, mouse_button_str);

    // handle setting/returning error on undefined host_key here

    // result
    const result = host_mouse_button.?.isPressed();

    var output_slice = outputs[0..n_outputs];

    var result_buff: []const u8 = undefined;

    if (result) {
        result_buff = "true";
    } else {
        result_buff = "false";
    }

    // return result here
    curr_plugin.returnBytes(&output_slice[0], result_buff);
}

pub export fn host_isButtonReleased(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const mouse_button_str = curr_plugin.inputBytes(&input_slice[0]);

    const host_mouse_button = std.meta.stringToEnum(Button, mouse_button_str);

    // handle setting/returning error on undefined host_key here

    // result
    const result = host_mouse_button.?.isReleased();

    var output_slice = outputs[0..n_outputs];

    var result_buff: []const u8 = undefined;

    if (result) {
        result_buff = "true";
    } else {
        result_buff = "false";
    }

    // return result here
    curr_plugin.returnBytes(&output_slice[0], result_buff);
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

    host_mouse_cursor.?.get(mouse_cursor_str).set();
}

pub export fn host_getMouseX(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = inputs;
    _ = n_inputs;
    _ = user_data;

    // curr_plugin
    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    // result
    const mouse_x = rl.getMouseX();

    var output_slice = outputs[0..n_outputs];

    var mouse_x_buf: [@sizeOf(i32)]u8 = undefined;

    std.fmt.bufPrint(&mouse_x_buf, "{d}", mouse_x);

    // return result here
    curr_plugin.returnBytes(&output_slice[0], mouse_x_buf);
}

pub export fn host_getMouseY(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = inputs;
    _ = n_inputs;
    _ = user_data;

    // curr_plugin
    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    // result
    const mouse_y = rl.getMouseY();

    var output_slice = outputs[0..n_outputs];

    var mouse_y_buf: [@sizeOf(i32)]u8 = undefined;

    std.fmt.bufPrint(&mouse_y_buf, "{d}", mouse_y);

    // return result here
    curr_plugin.returnBytes(&output_slice[0], mouse_y_buf);
}

pub export fn host_getMouseWheelMove(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = inputs;
    _ = n_inputs;
    _ = user_data;

    // curr_plugin
    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    // result
    const mouse_wheel_move = rl.getMouseWheelMove();

    var output_slice = outputs[0..n_outputs];

    var mouse_wheel_move_buf: [@sizeOf(i32)]u8 = undefined;

    std.fmt.bufPrint(&mouse_wheel_move_buf, "{d}", mouse_wheel_move);

    // return result here
    curr_plugin.returnBytes(&output_slice[0], mouse_wheel_move_buf);
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

pub fn exports() []extism.Function {
    // ======= MOUSE =======
    const h_mouse = extism.Function.init(
        "mouse",
        &[_]extism.c.ExtismValType{},
        &[_]extism.c.ExtismValType{extism.PTR},
        &host_mouse,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    const h_mouseFree = extism.Function.init(
        "mouseFree",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{},
        &host_freeMouse,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    // ======= MOUSE BUTTONS =======
    const h_isMouseButtonUp = extism.Function.init(
        "isMouseButtonUp",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        &host_isButtonUp,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );

    const h_isMouseButtonDown = extism.Function.init(
        "isMouseButtonDown",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        &host_isButtonDown,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );

    const h_isMouseButtonPressed = extism.Function.init(
        "isMouseButtonPressed",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        &host_isButtonPressed,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );

    const h_isMouseButtonReleased = extism.Function.init(
        "isMouseButtonReleased",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        &host_isButtonReleased,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    // ======= MOUSE CURSOR =======
    const h_setMouseCursor = extism.Function.init(
        "setMouseCursor",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        &host_setCursor,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    // ======= MOUSE POSITION =======
    const h_getMouseX = extism.Function.init(
        "getMouseX",
        &[_]extism.c.ExtismValType{},
        &[_]extism.c.ExtismValType{extism.PTR},
        &host_getMouseX,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );

    const h_getMouseY = extism.Function.init(
        "getMouseY",
        &[_]extism.c.ExtismValType{},
        &[_]extism.c.ExtismValType{extism.PTR},
        &host_getMouseY,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    // ======= MOUSE WHEEL MOVE =======
    const h_getMouseWheelMove = extism.Function.init(
        "getMouseWheelMove",
        &[_]extism.c.ExtismValType{},
        &[_]extism.c.ExtismValType{extism.PTR},
        &host_getMouseWheelMove,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );

    return [_]extism.Function{
        // ======= MOUSE =======
        h_mouse,
        h_mouseFree,
        // ======= MOUSE BUTTONS =======
        h_isMouseButtonUp,
        h_isMouseButtonDown,
        h_isMouseButtonPressed,
        h_isMouseButtonReleased,
        // ======= MOUSE CURSOR =======
        h_setMouseCursor,
        // ======= MOUSE POSITION =======
        h_getMouseX,
        h_getMouseY,
        // ======= MOUSE WHEEL MOVE =======
        h_getMouseWheelMove
    };
}
