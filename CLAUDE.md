# hex

Crystal port of [KokaKiwi/rust-hex](https://github.com/KokaKiwi/rust-hex) — encoding and decoding data into/from hexadecimal representation.

## Commands

```bash
shards install                          # install dependencies
shards update                           # update dependencies
crystal tool format --check src spec    # check formatting
crystal tool format src spec            # apply formatting
ameba src spec                          # lint
crystal spec                            # run tests
```

## Principles

- Upstream (rust-hex) behavior is the source of truth.
- Port behavior first, express with Crystal idioms only where semantics stay unchanged.
- All upstream tests must pass before marking a feature complete.
- Parity inventory under `plans/inventory/` tracks port status.

## Conventions

- Use `Bytes` (i.e. `Slice(UInt8)`) for binary data, never `String`.
- Free functions accept `Bytes | String` — internal conversion via `.to_slice`.
- Error type is `Hex::FromHexError` with `Kind` enum.
- Encoding tables are `StaticArray` constants computed at compile time.

## Relevant docs

- [Architecture](docs/architecture.md)
- [Development](docs/development.md)
- [Coding guidelines](docs/coding-guidelines.md)
- [Testing](docs/testing.md)
- [PR workflow](docs/pr-workflow.md)
