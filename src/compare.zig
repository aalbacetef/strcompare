const std = @import("std");
const hamming = @import("./hamming.zig");
const levenshtein = @import("./levenshtein.zig");

pub const Metrics = enum { Levenshtein, Damerau, Hamming };

pub fn compare(alloc: std.mem.Allocator, metric: Metrics, a: []const u8, b: []const u8) !f64 {
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

test "it should return 1.0 for strings that differ by 1 character" {
    const a = "asd";
    const b = "asda";

    const tol = 1e-6;
    const want = 1.0;

    const lev = try compare(std.testing.allocator, Metrics.Levenshtein, a, b);
    try std.testing.expectApproxEqRel(want, lev, tol);

    const dam = try compare(std.testing.allocator, Metrics.Damerau, a, b);
    try std.testing.expectApproxEqRel(want, dam, tol);
}
