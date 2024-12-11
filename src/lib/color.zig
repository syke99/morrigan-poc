const rl = @import("raylib");

pub const Color = enum {
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

    fn getColor(self: *Color) rl.Color {
        const color = switch (self) {
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
};
