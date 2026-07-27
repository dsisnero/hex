# hex — rust-hex Crystal Port

Upstream: https://github.com/KokaKiwi/rust-hex
Revision: e25a8701f7f6b5ec4acedffcb4a45cfb69cc34eb
Crate: hex v0.4.3

## Features

- [x] FromHexError — error type with InvalidHexCharacter, OddLength, InvalidStringLength
- [x] encode / encode_upper — free functions returning String
- [x] decode — free function returning Vec<u8>
- [x] encode_to_slice / encode_to_slice_upper — encode into existing buffer
- [x] decode_to_slice — decode into existing buffer
- [x] decode_in_slice — decode hex string in-place
- [x] ToHex trait — encode_hex, encode_hex_upper on AsRef<[u8]> types
- [x] FromHex trait — from_hex on Vec<u8> and [u8; N]
- [ ] serde support (optional)
