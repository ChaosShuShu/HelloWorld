## Disable Multi-threading in frame
```bash
--no-wpp --frame-threads 1 --pools 0 
```

## Parameters parsing errror

- client parse error: check long_options

## Intrinsic Optimization

Some CPU would treat the `cvtps2dq` as truncated version of `cvtdq2ps`, which could lead to performance degradation. To avoid this, we can use `_MM_SET_ROUNDING_MODE(_MM_ROUND_TOWARD_ZERO)`