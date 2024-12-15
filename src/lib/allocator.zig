const std = @import("std");

const Mouse = @import("mouse.zig").Mouse;
const Keyboard = @import("keyboard.zig").Keyboard;
const Color = @import("color.zig").Color;

var alc: *GlobalAllocator = {};

const GlobalAllocator = struct {
    allocator: std.mem.Allocator,
    hashMap: std.HashMap,

    fn init(self: *GlobalAllocator, alloc: std.mem.Allocator) void {
        self.allocator = alloc;

        self.hashMap = std.AutoHashMap(i32, usize).init(alloc);

        alc = self;
    }

    fn allocate(self: *GlobalAllocator, comptime T: type) i32 {
        _ = try self.allocator.create(@sizeOf(T));

        // generate i32, set it as the key and result of @intFromPtr(ptr)
        // as the value in self.hashMap
        // @intFromPtr(ptr);
        //
        // return generated i32 to be used
        return 0;
    }

    fn retrieve(self: *GlobalAllocator, comptime T: type, id: i32) *T {
        const ptr_int = self.hashMap.get(id);

        return @ptrFromInt(ptr_int);
    }

    fn free(self: *GlobalAllocator, id: i32) void {
        const ptr = try self.hashMap.get(id);

        self.hashMap.remove(id);

        self.allocator.destroy(ptr);
    }
};

pub fn init(allocator: std.mem.Allocator) void {
    GlobalAllocator.init(allocator);
}

pub fn allocate(comptime T: type) i32 {
    return alc.allocate(T);
}

pub fn free(id: i32) void {
    alc.free(id);
}

pub fn retrieve(comptime T: type, id: i32) *T {
    return alc.retrieve(T, id);
}

