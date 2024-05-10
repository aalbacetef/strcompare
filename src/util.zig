const std = @import("std");
const MatrixError = @import("./errors.zig").MatrixError;

pub const Matrix = struct {
    m: usize,
    n: usize,
    data: []u64,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, m: usize, n: usize) !Matrix {
        const mat = .{
            .allocator = allocator,
            .m = m,
            .n = n,
            .data = try allocator.alloc(u64, m * n),
        };

        const elems = m * n;
        for (0..elems) |k| {
            mat.data[k] = 0;
        }

        return mat;
    }

    pub fn deinit(self: Matrix) void {
        self.allocator.free(self.data);
    }

    fn toIndex(self: Matrix, i: usize, j: usize) !u64 {
        const index = i + (j * self.n);
        const max_indx = self.m * self.n;
        if (index >= max_indx) {
            return MatrixError.IndexOutOfBounds;
        }

        return index;
    }

    pub fn get(self: Matrix, i: usize, j: usize) !u64 {
        const index = try self.toIndex(i, j);
        return self.data[index];
    }

    pub fn set(self: Matrix, i: usize, j: usize, v: u64) !void {
        const index = try self.toIndex(i, j);
        self.data[index] = v;
    }
};

pub fn print_mat(mat: Matrix) !void {
    const m = mat.m;
    const n = mat.n;

    for (0..m) |i| {
        std.debug.print("|  ", .{});
        for (0..n) |j| {
            const v = try mat.get(i, j);
            std.debug.print("{d},  ", .{v});
        }
        std.debug.print("|\n", .{});
    }
}

test "it doesn't leak memory" {
    const mat = try Matrix.init(std.testing.allocator, 2, 2);
    defer mat.deinit();
}

test "it can get an element" {
    const mat = try Matrix.init(std.testing.allocator, 2, 2);
    defer mat.deinit();

    const v = try mat.get(1, 1);
    try std.testing.expect(v == 0);
}

test "it can set an element" {
    const mat = try Matrix.init(std.testing.allocator, 2, 2);
    defer mat.deinit();

    var v = try mat.get(1, 1);
    try std.testing.expect(v == 0);

    const want = 200;
    try mat.set(1, 1, want);
    v = try mat.get(1, 1);

    try std.testing.expect(v == want);
}
