const std = @import("std");
const StringCompareError = @import("./errors.zig").StringCompareError;

pub fn hamming(a: []const u8, b: []const u8) !u64 {
    const n = a.len;
    if (b.len != n) {
        return StringCompareError.LengthMismatch;
    }

    var s: u64 = 0;

    for (0..n) |k| {
        if (a[k] != b[k]) {
            s += 1;
        }
    }

    return s;
}

test "empty_strings" {
    const a: []const u8 = "";
    const b: []const u8 = "";

    const dist: u64 = try hamming(a, b);
    const want: u64 = 0;

    try std.testing.expect(dist == want);
}

test "mismatched_lengths" {
    const err = hamming("a", "");
    try std.testing.expectError(StringCompareError.LengthMismatch, err);
}

test "exactly_one_distance" {
    try testFn("ava", "aba", 1);
}

test "exactly_three_distances" {
    try testFn("ava", "cat", 3);
}

fn testFn(a: []const u8, b: []const u8, want: u64) !void {
    const dist: u64 = try hamming(a, b);
    try std.testing.expectEqual(want, dist);
}

test "errors on length mismatch" {
    try std.testing.expectError(
        StringCompareError.LengthMismatch,
        hamming("asd", "asdasd"),
    );
}
