const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "strcompare",
        .root_source_file = .{ .path = "./src/strcompare.zig" },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(lib);

    const test_step = b.step("test", "Run library tests");
    const t = b.addTest(.{
        .root_source_file = .{ .path = "./src/strcompare.zig" },
        .target = target,
        .optimize = optimize,
    });

    const r = b.addRunArtifact(t);
    test_step.dependOn(&r.step);
}
