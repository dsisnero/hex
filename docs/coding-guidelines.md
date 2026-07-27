# Coding guidelines

## Types

- Use `Bytes` (`Slice(UInt8)`) for binary data, never `String`.
- Free functions accept `Bytes | String` and convert internally via `.to_slice`.

## Errors

- Use `Hex::FromHexError` (a custom `Exception` subclass) for all failure paths.
- The `Kind` enum distinguishes `InvalidHexCharacter`, `OddLength`, `InvalidStringLength`.

## Tables

- Encoding tables are module-level `Slice(UInt8)` constants computed at compile time.
- The decode table is a private 256-entry `Slice(UInt8)`.

## Porting

- Upstream `rust-hex` behavior is the source of truth.
- Port behavior first; Crystal idioms only where semantics stay unchanged.
- When inlining an upstream helper, verify the callers' behavior matches exactly.
