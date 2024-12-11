const extism = @import("extism");

const libraylib = @import("lib/window.zig");

pub fn functions() *[]extism.Function {
    var h_makeWindow = extism.Function.init(
        "makeWindow",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{},
        &host_makeWindow,
        @constCast(@as(*const anyopaque, @ptrCast("user data"))),
    );
    defer h_makeWindow.deinit();

    return &[_]extism.Function{h_makeWindow};
}

export fn host_makeWindow(caller: ?*extism.c.ExtismCurrentPlugin, inputs: [*c]const extism.c.ExtismVal, n_inputs: u64, outputs: [*c]extism.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    _ = outputs;
    _ = n_outputs;
    _ = user_data;

    var curr_plugin = extism.CurrentPlugin.getCurrentPlugin(caller orelse unreachable);

    // retrieve the key from the plugin
    var input_slice = inputs[0..n_inputs];
    const windowStr = curr_plugin.inputBytes(&input_slice[0]);

    try libraylib.makeWindow(windowStr);
}
