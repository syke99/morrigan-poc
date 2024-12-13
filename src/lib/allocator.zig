const std = @import("std");

const Mouse = @import("mouse.zig").Mouse;
const Keyboard = @import("keyboard.zig").Keyboard;
const Color = @import("color.zig").Color;

var alc: *GlobalAllocator = null;

pub const GlobalAllocator = struct {
    allocator: std.mem.Allocator,
    hashMap: std.HashMap,

    pub fn init(self: *GlobalAllocator, alloc: std.mem.Allocator) void {
        self.allocator = alloc;

        self.hashMap = std.AutoHashMap(i32, usize).init(alloc);

        alc = self;
    }

    fn allocate(comptime T: type) i32 {
        _ = try alc.create(@sizeOf(T));

        // generate i32, set it as the key and result of @intFromPtr(ptr)
        // as the value in self.hashMap
        // @intFromPtr(ptr);
        //
        // return generated i32 to be used
        return 0;
    }


    fn free(self: *GlobalAllocator, id: i32) void {
        const ptr = try self.hashMap.get(id);

        self.allocator.destroy(ptr);
    }
};


pub fn allocate(comptime T: type) i32 {
    alc.allocate(T);
}

pub fn free(id: i32) void {
    alc.free(id);
}

