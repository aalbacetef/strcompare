# strcompare


`strcompare` is a zig library implementing 3 of the most common string comparison algorithms:
 
 - Hamming distance
 - Levenshtein distance 
 - Damerau-Levenshtein distance (specifically, the optimal string alignment distance)

## Usage 

The library provides two convenience functions: `similarity` and `distance`.

Both functions accept a `Metric` argument, one of:

```zig
pub const Metrics = enum { 
    Damerau,
    Hamming,
    Levenshtein,
};
```

#### distance 

`distance` accepts the following arguments:
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


Example:

```zig
const a = "kitten";
const b = "sitting";

const d = similarity(alloc, Metrics.Levenshtein, a, b);

std.debug.print("similarity: {d:.2%}\n", .{d}); 
// 
// similarity: 0.57%
//
```

