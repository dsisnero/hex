# Changelog

## 0.1.0 — unreleased

- Port upstream `rust-hex` v0.4.3: `Hex.encode`, `Hex.encode_upper`, `Hex.decode`, `Hex.decode_to_slice`, `Hex.decode_in_slice`, `Hex.encode_to_slice`, `Hex.encode_to_slice_upper`.
- Add `Hex::ToHex` mixin (`encode_hex` / `encode_hex_upper`) on `String`, `Slice(T)`, `Array(T)`.
- Add `Array(UInt8).from_hex` class method.
- Add `Hex::FromHexError` exception with `Kind` enum.
- Port all 14 upstream unit tests (26 Crystal specs).
- Add parity inventory under `plans/`.
