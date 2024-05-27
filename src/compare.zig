const std = @import("std");
const hamming = @import("./hamming.zig");
const levenshtein = @import("./levenshtein.zig");

pub const Metrics = enum { Levenshtein, Damerau, Hamming };

pub fn similarity(alloc: std.mem.Allocator, metric: Metrics, a: []const u8, b: []const u8) !f64 {
    const edit_distance = try distance(alloc, metric, a, b);
    const m = a.len;
    const n = b.len;
    const N: f64 = @floatFromInt(@max(m, n));
    const d: f64 = @floatFromInt(edit_distance);

    return 1.0 - (d / N);
}

pub fn distance(alloc: std.mem.Allocator, metric: Metrics, a: []const u8, b: []const u8) !u64 {
    return switch (metric) {
        .Levenshtein => try levenshtein.lev(alloc, a, b),
        .Damerau => try levenshtein.damerau(alloc, a, b),
        .Hamming => try hamming.hamming(a, b),
    };
}

test "it should return 3 for kitten-sitting" {
    const a = "kitten";
    const b = "sitting";

    const want = 3;

    const lev = try distance(std.testing.allocator, Metrics.Levenshtein, a, b);
    try std.testing.expectEqual(want, lev);

    const dam = try distance(std.testing.allocator, Metrics.Damerau, a, b);
    try std.testing.expectEqual(want, dam);
}

test "it should correctly compare strings that differ by 1 character" {
    const a = "asdalt";
    const b = "asdalg";

    const lev = try similarity(std.testing.allocator, Metrics.Levenshtein, a, b);
    const dam = try similarity(std.testing.allocator, Metrics.Damerau, a, b);

    const tol = 1e-6;
    const want = 1.0 - (1.0 / 6.0);

    try std.testing.expectApproxEqRel(want, lev, tol);
    try std.testing.expectApproxEqRel(want, dam, tol);
}

test "it should return 0.0 when comparing entirely different strings" {
    const a = "bbbbbbbb";
    const b = "asdalg";

    const lev = try similarity(std.testing.allocator, Metrics.Levenshtein, a, b);
    const dam = try similarity(std.testing.allocator, Metrics.Damerau, a, b);

    const tol = 1e-6;
    const want = 0.0;

    try std.testing.expectApproxEqRel(want, lev, tol);
    try std.testing.expectApproxEqRel(want, dam, tol);
}

test "it should return 1.0 when comparing identical different strings" {
    const a = "equal";
    const b = "equal";

    const lev = try similarity(std.testing.allocator, Metrics.Levenshtein, a, b);
    const dam = try similarity(std.testing.allocator, Metrics.Damerau, a, b);

    const tol = 1e-6;
    const want = 1.0;

    try std.testing.expectApproxEqRel(want, lev, tol);
    try std.testing.expectApproxEqRel(want, dam, tol);
}
