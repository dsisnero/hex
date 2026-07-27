# hex

Crystal port of [KokaKiwi/rust-hex](https://github.com/KokaKiwi/rust-hex) — encoding and decoding data into/from hexadecimal representation.

## Installation

Add the dependency to your `shard.yml`:

```yaml
dependencies:
  hex:
    github: dsisnero/hex
```

Run `shards install`.

## Usage

```crystal
require "hex"
```

### Encoding

Lowercase hex encoding via free function:

```crystal
hex_string = Hex.encode("Hello world!")
puts hex_string # => "48656c6c6f20776f726c6421"
```

Uppercase hex encoding:

```crystal
hex_string = Hex.encode_upper("Hello world!")
puts hex_string # => "48656C6C6F20776F726C6421"
```

Into an existing buffer:

```crystal
buf = Bytes.new(12 * 2)
Hex.encode_to_slice("Hello world!", buf)
puts String.new(buf) # => "48656c6c6f20776f726c6421"
```

### Decoding

```crystal
bytes = Hex.decode("48656c6c6f20776f726c6421")
puts String.new(bytes) # => "Hello world!"
```

Into an existing buffer:

```crystal
buf = Bytes.new(12)
Hex.decode_to_slice("48656c6c6f20776f726c6421", buf)
puts String.new(buf) # => "Hello world!"
```

In-place decoding (decodes hex string buffer into its first half):

```crystal
buf = "48656c6c6f20776f726c6421".to_slice.dup
Hex.decode_in_slice(buf)
puts String.new(buf[0, 12]) # => "Hello world!"
```

### Trait-style interface

`String`, `Bytes`, and `Array(UInt8)` all include `Hex::ToHex`:

```crystal
"Hello world!".encode_hex      # => "48656c6c6f20776f726c6421"
"Hello world!".encode_hex_upper # => "48656C6C6F20776F726C6421"
```

Array decoding via class method:

```crystal
Array(UInt8).from_hex("48656c6c6f20776f726c6421")
```

### Error handling

```crystal
Hex.decode("xyz") # raises Hex::FromHexError::InvalidHexCharacter
Hex.decode("abc") # raises Hex::FromHexError::OddLength
```

## Documentation

- [Architecture](docs/architecture.md)
- [Development](docs/development.md)
- [Coding guidelines](docs/coding-guidelines.md)
- [Testing](docs/testing.md)
- [PR workflow](docs/pr-workflow.md)

## License

MIT License — see [LICENSE](LICENSE).
