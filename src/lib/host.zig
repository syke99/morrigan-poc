const extism = @import("extism");

const libwindow = @import("window.zig");
const libkeyboard = @import("keyboard.zig");
const libmouse = @import("mouse.zig");
const libcolor = @import("color.zig");

pub const HostFunctions = struct {
    funcs: *[]extism.Function,

    pub fn init(self: *HostFunctions) *HostFunctions {
        const funcs = []extism.Function{
            libwindow.exports() ++
            libkeyboard.exports() ++
            libmouse.exports() ++
            libcolor.exports()
        };

        self.funcs = *funcs;

        return self;
    }

    pub fn deinit(self: *HostFunctions) void {
        const funcs = self.funcs.*;

        inline for (funcs) |f| {
            f.deinit();
        }
    }
};

pub fn functions(host_funcs: HostFunctions) *[]extism.Function {
    return host_funcs.funcs;
}
