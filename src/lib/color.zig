const std = @import("std");
const rl = @import("raylib");

const liballocator = @import("allocator.zig");

pub const ColorError = enum {
    AllocationError,
    DoesntExist
};

pub const Color = struct {
    id: i32,
    color: clr,
    rlColor: rl.Color,

    // ========== RAYLIB FUNCTION WRAPPERS ==========

    pub fn initByName(self: *Color, name: []const u8) error{ColorError}!i32 {
        // TODO: catch alloc error
        const id = liballocator.allocate(Color);

        self.id = id;

        const color = try getColorByName(name) catch ColorError.DoesntExist;
        // create UUID and set self.id equal

        self.color = color;

        const rlColor = getRaylibColor(color);

        self.rlColor = rlColor;

        return 0;
    }

    pub fn initByValues(self: *Color, r: u8, g: u8, b: u8, a: u8) i32 {
        // TODO: catch alloc error
        const id = liballocator.allocate(Color);

        self.id = id;

        const color = rl.Color.init(r, g, b, a);
        // create UUID and set self.id equal

        self.rlColor = color;

        return 0;
    }

    pub fn deinit(self: *Color) void {
        liballocator.free(self.id);
    }

    /// Get a Color from HSV values, hue [0..360], saturation/value [0..1]
    pub fn fromHSV(self: *Color, h: f32, s: f32, v: f32) error{ColorError}!i32 {
        const color = rl.Color.fromHSV(h, s, v);
        // create UUID and set self.id equal

        self.rlColor = color;

        return 0;
    }

    /// Get a Color from hexadecimal value
    pub fn fromHex(self: *Color, hex: u32) error{ColorError}!Color {
        const color = rl.Color.fromInt(hex);
        // create UUID and set self.id equal

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
    inline for (@typeInfo(clr).Enum.fields) |f| {
        if (std.mem.eql(u8, f.name, name)) {
            return @enumFromInt(f.value);
        }
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

// TODO:
// ========= INJECTED HOST FUNCTION(S) =========
