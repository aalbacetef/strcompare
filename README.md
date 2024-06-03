![CI status](https://github.com/aalbacetef/strcompare/actions/workflows/ci.yml/badge.svg)   [![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)


# strcompare


`strcompare` is a zig library implementing 3 of the most common string comparison algorithms:
 
 - Hamming distance
 - Levenshtein distance 
 - Damerau-Levenshtein distance (specifically, the optimal string alignment distance)

## Usage 

The library provides two convenience functions: `similarity` and `distance`.

Both functions accept a `Metrics` argument, one of:

```zig
pub const Metrics = enum { 
    Damerau,
    Hamming,
    Levenshtein,
};
```

#### distance 

`distance` will return the edit distance, a `u64`.

It accepts the following arguments:
 - alloc: an `std.mem.Allocator`
 - metric: one of the `Metrics`
 - a, b: strings to compare

Example:

```zig
const a = "kitten";
const b = "sitting";

const d = distance(alloc, Metrics.Levenshtein, a, b);

std.debug.print("distance: {d}\n", .{d}); 
// 
// distance: 3
//
```

#### similarity

`similarity` returns a weighted distance, that is, an `f64` from `0.0` to `1.0`. 
It will return `0.0` if the strings differ completely and `1.0` if they are identical.

It accepts the following arguments:
 - alloc: an `std.mem.Allocator`
 - metric: one of the `Metrics`
 - a, b: strings to compare


Example:

```zig
const a = "kitten";
const b = "sitting";

const d = similarity(alloc, Metrics.Levenshtein, a, b);

std.debug.print("similarity: {d:.0%}\n", .{d*100.0}); 
// 
// similarity: 0.57%
//
```

## Installing

After acquiring the repo's code, run:

```bash
zig fetch --save ./path/to/strcompare 
```

then add the following to your `build.zig`

```zig
    const pkg = b.dependency("strcompare", .{});
    exe.root_module.addImport("strcompare", pkg.module("strcompare"));

```

Do the same for your tests:

```zig

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe_unit_tests.root_module.addImport("strcompare", pkg.module("strcompare"));

```

You should now be able to import the module with:

```zig
const strcompare = @import("strcompare");
const Metrics = strcompare.Metrics;
const distance = strcompare.distance;
const similarity = strcompare.similarity;

fn dist() !void {
    const a = "a";
    const b = "bb";
    const alloc = std.heap.page_allocator;

    const d = try distance(alloc, Metrics.Levenshtein, a, b);
    std.debug.print("distance: {d}\n", .{d});
}

```
