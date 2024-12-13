const std = @import("std");
const extism = @import("extism");

const libhost = @import("host.zig");
const liballocator = @import("allocator.zig");

pub const App = struct {
    plugin: extism.Plugin,

    pub fn init(self: *App, allocator: std.mem.Allocator) !*App {
        // init global allocator for memory management
        liballocator.GlobalAllocator.init(allocator);

        self.allocator = allocator;

        const wasm = extism.manifest.WasmFile{
            .path = "wasm/tinyplugin.wasm",
        };
        const manifest = .{ .wasm = &[_]extism.manifest.Wasm{ .{ .wasm_file = wasm}} };

        var plugin = extism.Plugin.initFromManifest(
            allocator,
            manifest,
            libhost.functions(),
            true,
        );
        defer plugin.deinit();

        return &plugin;
    }

    pub fn call(self: *App, name: []const u8, input: []const u8) ![]const u8 {
        self.plugin.call(name, input);
    }
};