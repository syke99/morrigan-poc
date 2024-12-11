const std = @import("std");
const extism = @import("extism");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ========== CREATE EXECUTABLE ==========

    const exe = b.addExecutable(.{
        .name = "morrigan-poc",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // ========== CREATE/LINK DEPENDENCIES ==========

    const raylib_dep = b.dependency("raylib-zig", .{
        .target = target,
        .optimize = optimize,
    });

    const raylib = raylib_dep.module("raylib");
    const raygui = raylib_dep.module("raygui");
    const raylib_artifact = raylib_dep.artifact("raylib");

    exe.linkLibrary(raylib_artifact);
    exe.root_module.addImport("raylib", raylib);
    exe.root_module.addImport("raygui", raygui);

    extism.addLibrary(exe, b);

    // ========== BUNDLE STATIC ASSETS ==========

    const install = b.getInstallStep();
    const install_data = b.addInstallDirectory(.{
        .source_dir = .{
            .src_path = .{
                .owner = b,
                .sub_path = "src/wasm"
            }
        },
        .install_dir = .{ .prefix = {} },
        .install_subdir = "wasm",
    });
    install.dependOn(&install_data.step);

    // ========== INSTALL EXECUTABLE ==========

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(install);

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
