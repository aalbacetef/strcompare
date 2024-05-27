const std = @import("std");
const util = @import("./util.zig");
const Matrix = util.Matrix;

pub fn lev(alloc: std.mem.Allocator, a: []const u8, b: []const u8) !u64 {
    const m = a.len;
    const n = b.len;

    const mat = try Matrix.init(alloc, m + 1, n + 1);
    defer mat.deinit();

    for (0..m + 1) |k| {
        try mat.set(k, 0, k);
    }

    for (0..n + 1) |k| {
        try mat.set(0, k, k);
    }

    for (1..mat.n) |j| {
        for (1..mat.m) |i| {
            var cost: u64 = 1;
            if (a[i - 1] == b[j - 1]) {
                cost = 0;
            }

            try mat.set(i, j, @min(
                try mat.get(i - 1, j) + 1,
                try mat.get(i, j - 1) + 1,
                try mat.get(i - 1, j - 1) + cost,
            ));
        }
    }

    return mat.get(m, n);
}

pub fn damerau(alloc: std.mem.Allocator, a: []const u8, b: []const u8) !u64 {
    const m = a.len;
    const n = b.len;

    const mat = try Matrix.init(alloc, m + 1, n + 1);
    defer mat.deinit();

    for (0..(m + 1)) |k| {
        try mat.set(k, 0, k);
    }

    for (0..(n + 1)) |k| {
        try mat.set(0, k, k);
    }

    for (1..(m + 1)) |i| {
        for (1..(n + 1)) |j| {
            var cost: u64 = 1;
            if (a[i - 1] == b[j - 1]) {
                cost = 0;
            }

            try mat.set(i, j, @min(
                try mat.get(i - 1, j) + 1,
                try mat.get(i, j - 1) + 1,
                try mat.get(i - 1, j - 1) + cost,
            ));

            const larger_than_1 = (i > 1) and (j > 1);
            const in_bounds = (i < m) and (j < n);
            const valid_index = larger_than_1 and in_bounds;

            if (valid_index and (a[i] == b[j - 1]) and (a[i - 1] == b[j])) {
                try mat.set(i, j, @min(
                    try mat.get(i, j),
                    try mat.get(i - 2, j - 2) + 1,
                ));
            }
        }
    }

    return mat.get(m, n);
}

test "it should calculate correctly" {
    const a = "asdffgghabvc";
    const b = "asdafggaaccc";

    const want: u64 = 4;
    const v1 = try lev(std.testing.allocator, a, b);
    const v2 = try damerau(std.testing.allocator, a, b);

    try std.testing.expect(v1 == want);
    try std.testing.expect(v2 == want);
}

test "it should detect strings of different lengths are different" {
    const a = "asdffgghabv";
    const b = "asdafggaaccc";

    const v1 = try lev(std.testing.allocator, a, b);
    const v2 = try damerau(std.testing.allocator, a, b);

    const want: u64 = 5;
    try std.testing.expect(v1 == want);
    try std.testing.expect(v2 == want);
}
