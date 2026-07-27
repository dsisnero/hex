# Architecture

`hex` is a single-module Crystal port of `rust-hex`.

## Module layout

- `Hex` — top-level module with free functions: `encode`, `encode_upper`, `decode`, `decode_to_slice`, `decode_in_slice`, `encode_to_slice`, `encode_to_slice_upper`.
- `Hex::FromHexError` — exception type with `Kind` enum (`InvalidHexCharacter`, `OddLength`, `InvalidStringLength`).
- `Hex::ToHex` — mixin providing `encode_hex` / `encode_hex_upper` (extended on `Slice(T)`, `Array(T)`, `String`).

## Decode strategy

A 256-entry lookup table (`DECODE_TABLE`) maps ASCII byte values to hex digit values (0–15), with 0xFF sentinel for invalid characters. The `val` helper reads two bytes via the table and merges them into one decoded byte.

## Encode strategy

Two compile-time constant lookup tables (`HEX_CHARS_LOWER`, `HEX_CHARS_UPPER`) map 4-bit nibbles to ASCII hex characters. `encode_to_slice`/`encode_to_slice_upper` iterate input bytes and write two output bytes per input byte.
