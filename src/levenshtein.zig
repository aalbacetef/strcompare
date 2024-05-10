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

fn head(s: []const u8) []const u8 {
    if (s.len == 0) {
        return "";
    }

    return s[0..1];
}

fn tail(s: []const u8) []const u8 {
    if (s.len < 2) {
        return "";
    }

    return s[1..];
}

test "it should return the first character" {
    const v = head("asd");
    try std.testing.expectEqualStrings("a", v);
}

test "it should return the first character if a single char" {
    const v = head("a");
    try std.testing.expectEqualStrings("a", v);
}

test "it should return the tail of the string for multiple characters" {
    const v = tail("asd");
    try std.testing.expectEqualStrings("sd", v);
}

test "it should return the tail of the string for single char" {
    const v = tail("a");
    try std.testing.expectEqual("", v);
}

test "it should calculate correctly" {
    const a = "asdffgghabvc";
    const b = "asdafggaaccc";

    const want: u64 = 4;
    const v = try lev(std.testing.allocator, a, b);

    try std.testing.expect(v == want);
}
