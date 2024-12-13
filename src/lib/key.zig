const std = @import("std");
const rl = @import("raylib");
const extism = @import("extism");

pub const KeyboardError = enum {
    AllocationError
};

pub const Keyboard = struct {
    id: i32,
    keys: [Key.KeyTable.len]Key,

    pub fn init(self: *Keyboard) error{KeyboardError}!i32 {
        // create UUID and set self.id equal
        _ = self;

        // store UUID and self in global allocator map

        // if error allocating Keyboard, return MouseError.AllocationError

        // return UUID
        return 0;
    }

    pub fn deinit(self: *Keyboard) void {
        // get UUID from self
        _ = self;

        // pass to global allocator to destory
    }

    pub fn key(b: []const u8) error{KeyError}!Key {
        inline for (@typeInfo(Key).Enum.fields) |f| {
            if (std.mem.eql(u8, f.name, b)) {
                return @enumFromInt(f.value);
            }
        }
        return KeyError.DoesntExist;
    }
};

pub const KeyError = enum {
  DoesntExist
};

pub const Key = enum {
    null,
    apostrophe,
    comma,
    minus,
    period,
    slash,
    zero,
    one,
    two,
    three,
    four,
    five,
    six,
    seven,
    eight,
    nine,
    semicolon,
    equal,
    a,
    b,
    c,
    d,
    e,
    f,
    g,
    h,
    i,
    j,
    k,
    l,
    m,
    n,
    o,
    p,
    q,
    r,
    s,
    t,
    u,
    v,
    w,
    x,
    y,
    z,
    space,
    escape,
    enter,
    tab,
    backspace,
    insert,
    delete,
    right,
    left,
    up,
    down,
    page_up,
    page_down,
    home,
    end,
    caps_lock,
    scroll_lock,
    num_lock,
    print_screen,
    pause,
    f1,
    f2,
    f3,
    f4,
    f5,
    f6,
    f7,
    f8,
    f9,
    f10,
    f11,
    f12,
    left_shift,
    left_control,
    left_alt,
    left_super,
    right_shift,
    right_control,
    right_alt,
    right_super,
    kb_menu,
    left_bracket,
    backslash,
    right_bracket,
    grave,
    kp_0,
    kp_1,
    kp_2,
    kp_3,
    kp_4,
    kp_5,
    kp_6,
    kp_7,
    kp_8,
    kp_9,
    kp_decimal,
    kp_divide,
    kp_multiply,
    kp_subtract,
    kp_add,
    kp_enter,
    kp_equal,
    back,
    // menu,
    volume_up,
    volume_down,

    // ========== RAYLIB FUNCTION WRAPPERS ==========

    pub fn isUp(self: *Key) bool {
        return rl.isKeyUp(getRaylibKey(self));
    }

    pub fn isDown(self: *Key) bool {
        return rl.isKeyDown(getRaylibKey(self));
    }

    pub fn isPressed(self: *Key) bool {
        return rl.isKeyPressed(getRaylibKey(self));
    }

    pub fn isPressedRepeat(self: *Key) bool {
        return rl.isKeyPressedRepeat(getRaylibKey(self));
    }

    pub fn isPressedReleased(self: *Key) bool {
        return rl.isKeyReleased(getRaylibKey(self));
    }
};

fn getRaylibKey(k: Key) rl.KeyboardKey {
    const key = switch (k) {
        .null => rl.KeyboardKey.key_null,
        .apostrophe => rl.KeyboardKey.key_apostrophe,
        .comma => rl.KeyboardKey.key_comma,
        .minus => rl.KeyboardKey.key_minus,
        .period => rl.KeyboardKey.key_period,
        .slash => rl.KeyboardKey.key_slash,
        .zero => rl.KeyboardKey.key_zero,
        .one => rl.KeyboardKey.key_one,
        .two => rl.KeyboardKey.key_two,
        .three => rl.KeyboardKey.key_three,
        .four => rl.KeyboardKey.key_four,
        .five => rl.KeyboardKey.key_five,
        .six => rl.KeyboardKey.key_six,
        .seven => rl.KeyboardKey.key_seven,
        .eight => rl.KeyboardKey.key_eight,
        .nine => rl.KeyboardKey.key_nine,
        .semicolon => rl.KeyboardKey.key_semicolon,
        .equal => rl.KeyboardKey.key_equal,
        .a => rl.KeyboardKey.key_a,
        .b => rl.KeyboardKey.key_b,
        .c => rl.KeyboardKey.key_c,
        .d => rl.KeyboardKey.key_d,
        .e => rl.KeyboardKey.key_e,
        .f => rl.KeyboardKey.key_f,
        .g => rl.KeyboardKey.key_g,
        .h => rl.KeyboardKey.key_h,
        .i => rl.KeyboardKey.key_i,
        .j => rl.KeyboardKey.key_j,
        .k => rl.KeyboardKey.key_k,
        .l => rl.KeyboardKey.key_l,
        .m => rl.KeyboardKey.key_m,
        .n => rl.KeyboardKey.key_n,
        .o => rl.KeyboardKey.key_o,
        .p => rl.KeyboardKey.key_p,
        .q => rl.KeyboardKey.key_q,
        .r => rl.KeyboardKey.key_r,
        .s => rl.KeyboardKey.key_s,
        .t => rl.KeyboardKey.key_t,
        .u => rl.KeyboardKey.key_u,
        .v => rl.KeyboardKey.key_v,
        .w => rl.KeyboardKey.key_w,
        .x => rl.KeyboardKey.key_x,
        .y => rl.KeyboardKey.key_y,
        .z => rl.KeyboardKey.key_z,
        .space => rl.KeyboardKey.key_space,
        .escape => rl.KeyboardKey.key_escape,
        .enter => rl.KeyboardKey.key_enter,
        .tab => rl.KeyboardKey.key_tab,
        .backspace => rl.KeyboardKey.key_backspace,
        .insert => rl.KeyboardKey.key_insert,
        .delete => rl.KeyboardKey.key_delete,
        .right => rl.KeyboardKey.key_right,
        .left => rl.KeyboardKey.key_left,
        .up => rl.KeyboardKey.key_up,
        .down => rl.KeyboardKey.key_down,
        .page_up => rl.KeyboardKey.key_page_up,
        .page_down => rl.KeyboardKey.key_page_down,
        .home => rl.KeyboardKey.key_home,
        .end => rl.KeyboardKey.key_end,
        .caps_lock => rl.KeyboardKey.key_caps_lock,
        .scroll_lock => rl.KeyboardKey.key_scroll_lock,
        .num_lock => rl.KeyboardKey.key_num_lock,
        .print_screen => rl.KeyboardKey.key_print_screen,
        .pause => rl.KeyboardKey.key_pause,
        .f1 => rl.KeyboardKey.key_f1,
        .f2 => rl.KeyboardKey.key_f2,
        .f3 => rl.KeyboardKey.key_f3,
        .f4 => rl.KeyboardKey.key_f4,
        .f5 => rl.KeyboardKey.key_f5,
        .f6 => rl.KeyboardKey.key_f6,
        .f7 => rl.KeyboardKey.key_f7,
        .f8 => rl.KeyboardKey.key_f8,
        .f9 => rl.KeyboardKey.key_f9,
        .f10 => rl.KeyboardKey.key_f10,
        .f11 => rl.KeyboardKey.key_f11,
        .f12 => rl.KeyboardKey.key_f12,
        .left_shift => rl.KeyboardKey.key_left_shift,
        .left_control => rl.KeyboardKey.key_left_control,
        .left_alt => rl.KeyboardKey.key_left_alt,
        .left_super => rl.KeyboardKey.key_left_super,
        .right_shift => rl.KeyboardKey.key_right_shift,
        .right_control => rl.KeyboardKey.key_right_control,
        .right_alt => rl.KeyboardKey.key_right_alt,
        .right_super => rl.KeyboardKey.key_right_super,
        .kb_menu => rl.KeyboardKey.key_kb_menu,
        .left_bracket => rl.KeyboardKey.key_left_bracket,
        .backslash => rl.KeyboardKey.key_backslash,
        .right_bracket => rl.KeyboardKey.key_right_bracket,
        .grave => rl.KeyboardKey.key_grave,
        .kp_0 => rl.KeyboardKey.key_kp_0,
        .kp_1 => rl.KeyboardKey.key_kp_1,
        .kp_2 => rl.KeyboardKey.key_kp_2,
        .kp_3 => rl.KeyboardKey.key_kp_3,
        .kp_4 => rl.KeyboardKey.key_f4,
        .kp_5 => rl.KeyboardKey.key_kp_5,
        .kp_6 => rl.KeyboardKey.key_kp_6,
        .kp_7 => rl.KeyboardKey.key_kp_7,
        .kp_8 => rl.KeyboardKey.key_kp_8,
        .kp_9 => rl.KeyboardKey.key_kp_9,
        .kp_decimal => rl.KeyboardKey.key_kp_decimal,
        .kp_divide => rl.KeyboardKey.key_kp_divide,
        .kp_multiply => rl.KeyboardKey.key_kp_multiply,
        .kp_subtract => rl.KeyboardKey.key_kp_subtract,
        .kp_add => rl.KeyboardKey.key_kp_add,
        .kp_enter => rl.KeyboardKey.key_enter,
        .kp_equal => rl.KeyboardKey.key_kp_equal,
        .back => rl.KeyboardKey.key_back,
        // .menu => rl.KeyboardKey.key_menu,
        .volume_up => rl.KeyboardKey.key_volume_up,
        .volume_down => rl.KeyboardKey.key_volume_down,
    };

    return key;
}

// ========= INJECTED HOST FUNCTION(S) =========

// TODO: init/deinit functions for Keyboard once global allocator is built

pub export fn host_isKeyUp(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = outputs;
    _ = n_outputs;
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const key_str = curr_plugin.inputBytes(&input_slice[0]);

    const host_key = std.meta.stringToEnum(Key, key_str);

    // handle setting/returning error on undefined host_key here
    
    // result
    _ = host_key.?.?.isUp();

    // return result here
    // curr_plugin.returnBytes(val: *c.ExtismVal, data: []const u8)
}

pub export fn host_isKeyDown(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = outputs;
    _ = n_outputs;
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const key_str = curr_plugin.inputBytes(&input_slice[0]);

    const host_key = std.meta.stringToEnum(Key, key_str);

    // result
    _ = host_key.?.isDown();

    // return result here
    // curr_plugin.returnBytes(val: *c.ExtismVal, data: []const u8)
}

pub export fn host_isKeyPressed(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = outputs;
    _ = n_outputs;
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const key_str = curr_plugin.inputBytes(&input_slice[0]);

    const host_key = std.meta.stringToEnum(Key, key_str);

    // result
    _ = host_key.?.isPressed();

    // return result here
    // curr_plugin.returnBytes(val: *c.ExtismVal, data: []const u8)
}

pub export fn host_isKeyPressedRepeat(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = outputs;
    _ = n_outputs;
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const key_str = curr_plugin.inputBytes(&input_slice[0]);

    const host_key = std.meta.stringToEnum(Key, key_str);

    // result
    _ = host_key.?.isPressedRepeat();

    // return result here
    // curr_plugin.returnBytes(val: *c.ExtismVal, data: []const u8)
}

pub export fn host_isKeyPressedReleased(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = outputs;
    _ = n_outputs;
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const key_str = curr_plugin.inputBytes(&input_slice[0]);

    const host_key = std.meta.stringToEnum(Key, key_str);

    // result
    _ = host_key.?.isPressedReleased();

    // return result here
    // curr_plugin.returnBytes(val: *c.ExtismVal, data: []const u8)
}

