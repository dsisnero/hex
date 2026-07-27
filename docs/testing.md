# Testing

## Running tests

```bash
crystal spec
```

## Test layout

- `spec/hex_spec.cr` — all specs in a single file, organized by `describe` blocks.

## Parity

Tests are direct ports of upstream `rust-hex` unit tests. Each upstream test maps to one or more Crystal `it` blocks with the same assertions. Where upstream uses `Result` return types, Crystal uses `expect_raises` for error paths.

## Upstream test index

| Upstream test | Crystal spec |
|---|---|
| `test_encode_to_slice` | `encode_to_slice` block |
| `test_decode_to_slice` | `decode_to_slice` block |
| `test_encode` | `encode` block |
| `test_decode` | `decode` block |
| `test_from_hex_okay_str` | `from_hex` block |
| `test_from_hex_okay_bytes` | `from_hex` block |
| `test_invalid_length` | `from_hex` block |
| `test_invalid_char` | `from_hex` block |
| `test_empty` | `from_hex` block |
| `test_from_hex_whitespace` | `from_hex` block |
| `test_from_hex_array` | `from_hex array` block |
| `test_to_hex` | `to_hex` block |
| `test_unsized_to_hex` | `unsized to_hex` block |
| `test_display` | `FromHexError display` block |
