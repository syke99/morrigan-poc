const std = @import("std");
const extism = @import("extism");

const libhost = @import("host.zig");

pub const App = struct {
    allocator: std.mem.Allocator,

    plugin: extism.Plugin,

    pub fn init(self: *App, allocator: std.mem.Allocator) !*App {
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
        self.call(name, input);
    }
};