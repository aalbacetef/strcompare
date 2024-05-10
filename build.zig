const std = @import("std");

const Lib = struct {
    name: []const u8,
    path: []const u8,
    with_tests: bool = true,
};

const libs: []const Lib = &.{
    .{ .name = "hamming", .path = "src/hamming.zig" },
    .{ .name = "levenshtein", .path = "src/levenshtein.zig" },
    .{ .name = "util", .path = "src/util.zig" },
};

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run library tests");

    for (libs) |l| {
        b.installArtifact(b.addStaticLibrary(.{
            .name = l.name,
            .root_source_file = .{ .path = l.path },
            .target = target,
            .optimize = optimize,
        }));

        if (l.with_tests) {
            const t = b.addTest(.{
                .root_source_file = .{ .path = l.path },
                .target = target,
                .optimize = optimize,
            });

            const r = b.addRunArtifact(t);
            test_step.dependOn(&r.step);
        }
    }
}
