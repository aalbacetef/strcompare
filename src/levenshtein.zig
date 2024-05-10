const std = @import("std");
const util = @import("./util.zig");
const Matrix = util.Matrix;

// pub fn levenshtein(alloc: std.mem.Allocator, a: []const u8, b: []const u8) !u64 {
//     const s = lev(a, b);
//     return s;
// const m = a.len;
// const n = b.len;
//
// if (n == 0) {
//     return m;
// }
//
// if (m == 0) {
//     return n;
// }
//
// var s: u64 = 0;
// var k: usize = 0;
//
// while (a[k] == b[k]) {
//     k += 1;
// }
//
// s += 1;
//
// const mat = Matrix.init(alloc, m, n);
// _ = mat;
// }

fn lev(a: []const u8, b: []const u8) u64 {
    const m = a.len;
    const n = b.len;

    if (n == 0) {
        return m;
    }

    if (m == 0) {
        return n;
    }

    if (a[0] == b[0]) {
        return lev(tail(a), tail(b));
    }

    const branch_one = lev(tail(a), b);
    if (branch_one == 0) {
        return 1;
    }

    const branch_two = lev(a, tail(b));
    if (branch_two == 0) {
        return 1;
    }

    const branch_three = lev(tail(a), tail(b));
    if (branch_three == 0) {
        return 1;
    }

    return 1 + @min(branch_three, @min(branch_one, branch_two));
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

    const v = lev(a, b);
    std.debug.print("v: {d}", .{v});
    // try std.testing.expect(v == 1);
}
