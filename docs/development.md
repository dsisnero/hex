# Development

## Prerequisites

- Crystal >= 1.21.0

## Setup

```bash
shards install
```

## Quality gates

```bash
crystal tool format --check src spec   # check formatting
ameba src spec                          # lint
crystal spec                            # run tests
```

## Parity workflow

See `plans/parity.md` for the feature roadmap and `plans/inventory/rust_port_inventory.tsv` for per-item porting status.

Upstream source is at `vendor/rust-hex/` (git submodule).
