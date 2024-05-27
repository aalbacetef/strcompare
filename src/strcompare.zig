const levenshtein_metrics = @import("./levenshtein.zig");
const hamming_metric = @import("./hamming.zig");
const util = @import("./util.zig");
const _compare = @import("./compare.zig");

pub const errors = @import("./errors.zig");

// export metric functions
pub const hamming = hamming_metric.hamming;
pub const levenshtein = levenshtein_metrics.lev;
pub const damerau = levenshtein_metrics.damerau;

// export helper functions and Metric enum
pub const Metrics = _compare.Metrics;
pub const compare = _compare.compare;
pub const distance = _compare.distance;

test {
    @import("std").testing.refAllDecls(@This());
}
