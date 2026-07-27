module Hex
  VERSION = "0.1.0"

  class FromHexError < Exception
    enum Kind
      InvalidHexCharacter
      OddLength
      InvalidStringLength
    end

    getter kind : Kind
    getter char : Char?
    getter index : Int32?

    def initialize(@kind : Kind, @char : Char? = nil, @index : Int32? = nil)
      msg = case kind
            when Kind::InvalidHexCharacter
              "Invalid character '#{char}' at position #{index}"
            when Kind::OddLength
              "Odd number of digits"
            when Kind::InvalidStringLength
              "Invalid string length"
            end
      super(msg)
    end
  end

  HEX_CHARS_LOWER = "0123456789abcdef".to_slice
  HEX_CHARS_UPPER = "0123456789ABCDEF".to_slice

  private DECODE_TABLE = begin
    t = Slice(UInt8).new(256, 255_u8)
    (0..9).each { |i| t[48 + i] = i.to_u8 }
    (0..5).each { |i| t[65 + i] = (10 + i).to_u8 }
    (0..5).each { |i| t[97 + i] = (10 + i).to_u8 }
    t
  end

  private def self.val(bytes : Bytes, idx : Int32) : UInt8
    upper = DECODE_TABLE[bytes[0]]
    lower = DECODE_TABLE[bytes[1]]
    if upper == 255_u8
      raise FromHexError.new(FromHexError::Kind::InvalidHexCharacter, bytes[0].chr, idx)
    end
    if lower == 255_u8
      raise FromHexError.new(FromHexError::Kind::InvalidHexCharacter, bytes[1].chr, idx + 1)
    end
    (upper << 4) | lower
  end

  def self.encode(data : Bytes) : String
    slice = Slice(UInt8).new(data.size * 2)
    encode_to_slice(data, slice)
    String.new(slice)
  end

  def self.encode(data : String) : String
    encode(data.to_slice)
  end

  def self.encode_upper(data : Bytes) : String
    slice = Slice(UInt8).new(data.size * 2)
    encode_to_slice_upper(data, slice)
    String.new(slice)
  end

  def self.encode_upper(data : String) : String
    encode_upper(data.to_slice)
  end

  def self.encode_to_slice(input : Bytes, output : Bytes) : Nil
    if input.size * 2 != output.size
      raise FromHexError.new(FromHexError::Kind::InvalidStringLength)
    end
    input.each_with_index do |byte, i|
      high = HEX_CHARS_LOWER[(byte >> 4) & 0x0F]
      low = HEX_CHARS_LOWER[byte & 0x0F]
      output[2 * i] = high
      output[2 * i + 1] = low
    end
  end

  def self.encode_to_slice_upper(input : Bytes, output : Bytes) : Nil
    if input.size * 2 != output.size
      raise FromHexError.new(FromHexError::Kind::InvalidStringLength)
    end
    input.each_with_index do |byte, i|
      high = HEX_CHARS_UPPER[(byte >> 4) & 0x0F]
      low = HEX_CHARS_UPPER[byte & 0x0F]
      output[2 * i] = high
      output[2 * i + 1] = low
    end
  end

  def self.decode(data : Bytes) : Array(UInt8)
    if data.size % 2 != 0
      raise FromHexError.new(FromHexError::Kind::OddLength)
    end
    buf = Slice(UInt8).new(data.size // 2, 0_u8)
    decode_to_slice(data, buf)
    buf.to_a
  end

  def self.decode(data : String) : Array(UInt8)
    decode(data.to_slice)
  end

  def self.decode_to_slice(data : Bytes, output : Bytes) : Nil
    if data.size % 2 != 0
      raise FromHexError.new(FromHexError::Kind::OddLength)
    end
    if data.size / 2 != output.size
      raise FromHexError.new(FromHexError::Kind::InvalidStringLength)
    end
    (0...output.size).each do |i|
      output[i] = val(data[2 * i, 2], 2 * i)
    end
  end

  def self.decode_to_slice(data : String, output : Bytes) : Nil
    decode_to_slice(data.to_slice, output)
  end

  def self.decode_in_slice(in_out : Bytes) : Nil
    if in_out.size % 2 != 0
      raise FromHexError.new(FromHexError::Kind::OddLength)
    end
    n = in_out.size // 2
    n.times do |i|
      in_out[i] = val(in_out[2 * i, 2].as(Bytes), 2 * i)
    end
  end

  module ToHex
    def encode_hex : String
      Hex.encode(to_slice)
    end

    def encode_hex_upper : String
      Hex.encode_upper(to_slice)
    end
  end

  module FromHex(T)
    abstract def from_hex(hex : Bytes | String)
  end
end

struct Slice(T)
  include Hex::ToHex
end

class Array(T)
  include Hex::ToHex

  def self.from_hex(hex : Bytes | String) : self
    Hex.decode(hex)
  end
end

class String
  include Hex::ToHex
end
