const std = @import("std");

const libapp = @import("lib/app.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var app = libapp.App.init(allocator);

    try app.call("run", "running application");
}
