const extism = @import("extism");

const window = @import("window.zig");
const keyboard = @import("keyboard.zig");
const mouse = @import("mouse.zig");

pub fn functions() *[]extism.Function {
    // ======= WINDOW =======
    var h_initWindow = extism.Function.init(
        "initWindow",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{},
        &window.host_initWindow,
        @constCast(@as(*const anyopaque, @ptrCast("user data"))),
    );
    defer h_initWindow.deinit();
    // ======= KEYS =======
    var h_isKeyUp = extism.Function.init(
        "isKeyUp",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        keyboard.host_isKeyUp,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    defer h_isKeyUp.deinit();

    var h_isKeyDown = extism.Function.init(
        "isKeyDown",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        keyboard.host_isKeyDown,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    defer h_isKeyDown.deinit();

    var h_isKeyPressed = extism.Function.init(
        "isKeyPressed",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        keyboard.host_isKeyPressed,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    defer h_isKeyPressed.deinit();

    var h_isKeyPressedRepeat = extism.Function.init(
        "isKeyPressedRepeat",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        keyboard.host_isKeyPressedRepeat,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    defer h_isKeyPressedRepeat.deinit();

    var h_isKeyPressedReleased = extism.Function.init(
        "isKeyPressedReleased",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        keyboard.host_isKeyPressedReleased,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    defer h_isKeyPressedReleased.deinit();
    // ======= MOUSE BUTTONS =======
    var h_isMouseButtonUp = extism.Function.init(
        "isMouseButtonUp",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        mouse.host_isMouseButtonUp,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    defer h_isMouseButtonUp.deinit();

    var h_isMouseButtonDown = extism.Function.init(
        "isMouseButtonDown",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        mouse.host_isMouseButtonDown,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    defer h_isMouseButtonDown.deinit();

    var h_isMouseButtonPressed = extism.Function.init(
        "isMouseButtonPressed",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        mouse.host_isMouseButtonPressed,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    defer h_isMouseButtonPressed.deinit();

    var h_isMouseButtonReleased = extism.Function.init(
        "isMouseButtonReleased",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        mouse.host_isMouseButtonReleased,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    defer h_isMouseButtonReleased.deinit();
    // ======= MOUSE CURSOR =======
    var h_setMouseCursor = extism.Function.init(
        "setMouseCursor",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        mouse.host_setMouseCursor,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    defer h_setMouseCursor.deinit();
    // ======= MOUSE POSITION =======
    var h_getMouseX = extism.Function.init(
        "getMouseX",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        mouse.host_getMouseX,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    defer h_getMouseX.deinit();

    var h_getMouseY = extism.Function.init(
        "getMouseY",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        mouse.host_getMouseY,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    defer h_getMouseY.deinit();
    // ======= MOUSE POSITION =======
    var h_getMouseWheelMove = extism.Function.init(
        "getMouseWheelMove",
        &[_]extism.c.ExtismValType{extism.PTR},
        &[_]extism.c.ExtismValType{extism.PTR},
        mouse.host_getMouseWheelMove,
        @constCast(@as(*const anyopaque, @ptrCast("user data")))
    );
    defer h_getMouseWheelMove.deinit();

    return &[_]extism.Function{
        // ======= WINDOW =======
        h_initWindow,
        // ======= KEYS =======
        h_isKeyUp,
        h_isKeyDown,
        h_isKeyPressed,
        h_isKeyPressedRepeat,
        h_isKeyPressedReleased,
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
        // ======= MOUSE POSITION =======
        h_getMouseWheelMove
    };
}
