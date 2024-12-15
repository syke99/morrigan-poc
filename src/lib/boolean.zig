const std = @import("std");

pub const Boolean = struct {
    boolean: bool,

    pub fn init(self: *Boolean, boolean: bool) *Boolean {
        self.boolean = boolean;
    }

    pub fn toString(self: *Boolean) []const u8 {
        if (self.boolean) {
            return "true";
        }
        return "false";
    }

    pub fn toInt(self: *Boolean) u8 {
        if (self.boolean) {
            return 1;
        }
        return 0;
    }
};