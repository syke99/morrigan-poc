const std = @import("std");
const rl = @import("raylib");
const extism = @import("extism");

const liballocator = @import("allocator.zig");

pub const ColorError = enum {
    AllocationError,
    DoesntExist
};

const InitValueTypes = union {
    name: []const u8,
    rgba: []const u8,
    hsv: []f32,
    hex: u32,
};

pub const Color = struct {
    id: i32,
    color: clr,
    rlColor: rl.Color,

    // ========== RAYLIB FUNCTION WRAPPERS ==========

    pub fn init(self: *Color, inputs: InitValueTypes) error{ColorError}!*Color {
        switch (inputs) {
            .name => |*n| {
                // TODO: catch alloc error
                self = self.initByName(n.*);
            },
            .rgba => |*r| {
                const rgba_slice = r.*;

                // TODO: catch alloc error
                self = self.initByValues(rgba_slice[0], rgba_slice[1], rgba_slice[2], rgba_slice[3]);
            },
            .hsv => |*r| {
                const hsv_slice = r.*;

                // TODO: catch alloc error
                self = self.fromHSV(hsv_slice[0], hsv_slice[1], hsv_slice[2]);
            },
            .hex => |*h| {
                // TODO: catch alloc error
                self = self.fromHex(h.*);
            }
        }
    }

    fn initByName(self: *Color, name: []const u8) error{ColorError}!*Color {
        _ = self;

        // TODO: catch alloc error
        const id = liballocator.allocate(Color);

        const self_ptr = liballocator.retrieve(Color, id);

        self_ptr.id = id;

        const color = try getColorByName(name) catch ColorError.DoesntExist;
        // create UUID and set self.id equal

        self_ptr.color = color;

        const rlColor = getRaylibColor(color);

        self_ptr.rlColor = rlColor;

        return self_ptr;
    }

    fn initByValues(self: *Color, r: u8, g: u8, b: u8, a: u8) *Color {
        _ = self;

        // TODO: catch alloc error
        const id = liballocator.allocate(Color);

        const self_ptr = liballocator.retrieve(Color, id);

        self_ptr.id = id;

        const color = rl.Color.init(r, g, b, a);
        // create UUID and set self.id equal

        self_ptr.rlColor = color;

        return self_ptr;
    }

    pub fn deinit(self: *Color) void {
        liballocator.free(self.id);
    }

    /// Get a Color from HSV values, hue [0..360], saturation/value [0..1]
    fn fromHSV(self: *Color, h: f32, s: f32, v: f32) error{ColorError}!*Color {
        _ = self;

        // TODO: catch alloc error
        const id = liballocator.allocate(Color);

        const self_ptr = liballocator.retrieve(Color, id);

        self_ptr.id = id;

        const color = rl.Color.fromHSV(h, s, v);

        self_ptr.rlColor = color;

        return self_ptr;
    }

    /// Get a Color from hexadecimal value
    fn fromHex(self: *Color, hex: u32) error{ColorError}!i32 {
        const id = liballocator.allocate(Color);

        self.id = id;

        const color = rl.Color.fromInt(hex);

        self.rlColor = color;

        return 0;
    }

    /// Get hexadecimal value for a Color
    pub fn toHex(self: *Color) i32 {
        return rl.colorToInt(self);
    }

    /// Get color with alpha applied, alpha goes from 0.0 to 1.0
    pub fn fade(self: *Color, a: f32) i32 {
        const color = rl.fade(self, a);

        self.rlColor = color;

        return self.id;
    }

    /// Tints self with t, allocates a new Color
    /// and returns it
    pub fn tint(self: *Color, t: i32) i32 {
        const tint_Color = liballocator.retrieve(Color, t);

        const tinted_Color = rl.colorTint(self, tint_Color);

        const id = liballocator.allocate(tinted_Color);

        const tinted_Color_ptr = liballocator.retrieve(Color, id);

        tinted_Color_ptr = &tinted_Color;

        return id;
    }

    /// Get color with brightness correction, brightness factor goes from -1.0 to 1.0
    pub fn brightness(self: *Color, f: f32) i32 {
        const color = rl.colorBrightness(self, f);

        self.rlColor = color;

        return self.id;
    }

    /// Get color with contrast correction, contrast values between -1.0 and 1.0
    pub fn contrast(self: *Color, c: f32) i32 {
        const color = rl.colorContrast(self, c);

        self.rlColor = color;

        return self.id;
    }

    /// Get color with alpha applied, alpha goes from 0.0 to 1.0
    pub fn alpha(self: *Color, a: f32) i32 {
        const color = rl.colorAlpha(self, a);

        self.rlColor = color;

        return self.id;
    }
};

const clr = enum {
    light_gray,
    gray,
    dark_gray,
    yellow,
    gold,
    orange,
    pink,
    red,
    maroon,
    green,
    lime,
    dark_green,
    sky_blue,
    blue,
    dark_blue,
    purple,
    violet,
    dark_purple,
    beige,
    brown,
    dark_brown,
    white,
    black,
    blank,
    magenta,
    ray_white,
};

fn getColorByName(name: []const u8) error{ColorError}!clr {
    const color = std.meta.stringToEnum(clr, name);

    if (color) |c| {
        return c;
    }
    return ColorError.DoesntExist;
}

fn getRaylibColor(c: clr) rl.Color {
    const color = switch (c) {
        .light_gray => rl.Color.light_gray,
        .gray => rl.Color.gray,
        .dark_gray => rl.Color.dark_gray,
        .yellow => rl.Color.yellow,
        .gold => rl.Color.gold,
        .orange => rl.Color.orange,
        .pink => rl.Color.pink,
        .red => rl.Color.red,
        .maroon => rl.Color.maroon,
        .green => rl.Color.green,
        .lime => rl.Color.lime,
        .dark_green => rl.Color.dark_green,
        .sky_blue => rl.Color.sky_blue,
        .blue => rl.Color.blue,
        .dark_blue => rl.Color.dark_blue,
        .purple => rl.Color.purple,
        .violet => rl.Color.violet,
        .dark_purple => rl.Color.dark_purple,
        .beige => rl.Color.beige,
        .brown => rl.Color.brown,
        .dark_brown => rl.Color.dark_brown,
        .white => rl.Color.white,
        .black => rl.Color.black,
        .magenta => rl.Color.magenta,
        .ray_white => rl.Color.ray_white,

        else => rl.Color.blank
    };

    return color;
}

// TODO: finish injecting host functions and registering them
// ========= INJECTED HOST FUNCTION(S) =========

pub export fn host_initColorWithName(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const color_str = curr_plugin.inputBytes(&input_slice[0]);

    const host_clr = Color.init([1]InitValueTypes{color_str}) catch ColorError.DoesntExist;

    var output_slice = outputs[0..n_outputs];

    var id_buf: [@sizeOf(i32)]u8 = undefined;

    std.fmt.formatIntBuf(&id_buf, host_clr.id, 10, std.fmt.Case.lower, .{});

    curr_plugin.returnBytes(&output_slice[0], id_buf);
}

pub export fn host_initColorWithValues(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const color_r_buf = curr_plugin.inputBytes(&input_slice[0]);
    const color_g_buf = curr_plugin.inputBytes(&input_slice[1]);
    const color_b_buf = curr_plugin.inputBytes(&input_slice[2]);
    const color_a_buf = curr_plugin.inputBytes(&input_slice[3]);

    const init_inputs = InitValueTypes{.rgba = [_]u8{color_r_buf, color_g_buf, color_b_buf, color_a_buf}};

    const host_clr = Color.init(init_inputs) catch ColorError.DoesntExist;

    var output_slice = outputs[0..n_outputs];

    var id_buf: [@sizeOf(i32)]u8 = undefined;

    std.fmt.formatIntBuf(&id_buf, host_clr.id, 10, std.fmt.Case.lower, .{});

    curr_plugin.returnBytes(&output_slice[0], id_buf);
}

pub export fn host_freeColor(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = outputs;
    _ = n_outputs;
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const id_str = curr_plugin.inputBytes(&input_slice[0]);

    const id = try std.fmt.parseInt(i32, id_str, 10);

    var color: *Color = @ptrFromInt(id);

    color.deinit();
}

pub export fn host_colorFromHSV(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const color_h_buf = curr_plugin.inputBytes(&input_slice[0]);
    const color_s_buf = curr_plugin.inputBytes(&input_slice[0]);
    const color_v_buf = curr_plugin.inputBytes(&input_slice[0]);

    const color_h = try std.fmt.parseFloat(f32, color_h_buf, 10);
    const color_s = try std.fmt.parseFloat(f32, color_s_buf, 10);
    const color_v = try std.fmt.parseFloat(f32, color_v_buf, 10);

    const init_inputs = InitValueTypes{.hsv = [_]f32{color_h, color_s, color_v}};

    const host_clr = Color.init(color_h, init_inputs) catch ColorError.DoesntExist;

    var output_slice = outputs[0..n_outputs];

    var id_buf: [@sizeOf(i32)]u8 = undefined;

    std.fmt.formatIntBuf(&id_buf, host_clr.id, 10, std.fmt.Case.lower, .{});

    curr_plugin.returnBytes(&output_slice[0], id_buf);
}

pub export fn host_colorFromHex(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    var input_slice = inputs[0..n_inputs];

    const color_hex_buf = curr_plugin.inputBytes(&input_slice[0]);

    const color_hex = try std.fmt.parseInt(u32, color_hex_buf, 10);

    const host_clr = Color.init(InitValueTypes{.hex = color_hex}) catch ColorError.DoesntExist;

    var output_slice = outputs[0..n_outputs];

    var id_buf: [@sizeOf(i32)]u8 = undefined;

    std.fmt.formatIntBuf(&id_buf, host_clr.id, 10, std.fmt.Case.lower, .{});

    curr_plugin.returnBytes(&output_slice[0], id_buf);
}

pub fn exports() []extism.Function {
    const h_initColorWithName = extism.Function.init(
        "getColorByName",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        &host_initColorWithName,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );

    const h_initColorWithValues = extism.Function.init(
        "getColorByRGBA",
        &[_]extism.c.ExtismValType{extism.PTR, extism.PTR, extism.PTR, extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        &host_initColorWithValues,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );

    const h_fromHSV = extism.Function.init(
        "getColorByHSV",
        &[_]extism.c.ExtismValType{extism.PTR, extism.PTR, extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        &host_colorFromHSV,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );

    const h_fromHex = extism.Function.init(
        "getColorByHex",
        &[_]extism.c.ExtismValType{extism.PTR, extism.PTR, extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        &host_colorFromHex,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );

    return [_]extism.Function{
        h_initColorWithName,
        h_initColorWithValues,
        h_fromHSV,
        h_fromHex,
    };
}
