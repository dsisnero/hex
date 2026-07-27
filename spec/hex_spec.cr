require "./spec_helper"

describe Hex do
  describe "encode_to_slice" do
    it "encodes lowercase" do
      output = Slice(UInt8).new(4 * 2, 0_u8)
      Hex.encode_to_slice("kiwi".to_slice, output)
      output.should eq("6b697769".to_slice)
    end

    it "encodes uppercase" do
      output = Slice(UInt8).new(4 * 2, 0_u8)
      Hex.encode_to_slice_upper("kiwi".to_slice, output)
      output.should eq("6B697769".to_slice)
    end

    it "encodes longer strings" do
      output = Slice(UInt8).new(5 * 2, 0_u8)
      Hex.encode_to_slice("kiwis".to_slice, output)
      output.should eq("6b69776973".to_slice)

      Hex.encode_to_slice_upper("kiwis".to_slice, output)
      output.should eq("6B69776973".to_slice)
    end

    it "returns error on mismatched output size" do
      output = Slice(UInt8).new(100, 0_u8)
      expect_raises(Hex::FromHexError, "Invalid string length") do
        Hex.encode_to_slice("kiwis".to_slice, output)
      end
      expect_raises(Hex::FromHexError, "Invalid string length") do
        Hex.encode_to_slice_upper("kiwis".to_slice, output)
      end
    end
  end

  describe "decode_to_slice" do
    it "decodes correctly" do
      output = Slice(UInt8).new(4, 0_u8)
      Hex.decode_to_slice("6b697769".to_slice, output)
      output.should eq("kiwi".to_slice)
    end

    it "decodes longer strings" do
      output = Slice(UInt8).new(5, 0_u8)
      Hex.decode_to_slice("6b69776973".to_slice, output)
      output.should eq("kiwis".to_slice)
    end

    it "returns odd length error" do
      output = Slice(UInt8).new(4, 0_u8)
      expect_raises(Hex::FromHexError, "Odd number of digits") do
        Hex.decode_to_slice("6".to_slice, output)
      end
    end
  end

  describe "encode" do
    it "encodes a string" do
      Hex.encode("foobar").should eq("666f6f626172")
    end
  end

  describe "decode" do
    it "decodes a hex string" do
      Hex.decode("666f6f626172").should eq("foobar".bytes)
    end
  end

  describe "from_hex" do
    it "works with lowercase string" do
      Array(UInt8).from_hex("666f6f626172").should eq("foobar".bytes)
    end

    it "works with uppercase string" do
      Array(UInt8).from_hex("666F6F626172").should eq("foobar".bytes)
    end

    it "works with bytes" do
      Array(UInt8).from_hex("666f6f626172".to_slice).should eq("foobar".bytes)
    end

    it "works with uppercase bytes" do
      Array(UInt8).from_hex("666F6F626172".to_slice).should eq("foobar".bytes)
    end

    it "returns odd length error" do
      expect_raises(Hex::FromHexError, "Odd number of digits") do
        Array(UInt8).from_hex("1")
      end
      expect_raises(Hex::FromHexError, "Odd number of digits") do
        Array(UInt8).from_hex("666f6f6261721")
      end
    end

    it "returns invalid char error" do
      expect_raises(Hex::FromHexError, "Invalid character 'g' at position 3") do
        Array(UInt8).from_hex("66ag")
      end
    end

    it "handles empty string" do
      Array(UInt8).from_hex("").should be_empty
    end

    it "rejects whitespace" do
      expect_raises(Hex::FromHexError, "Invalid character ' ' at position 4") do
        Array(UInt8).from_hex("666f 6f62617")
      end
    end
  end

  describe "from_hex array" do
    it "decodes to correct byte array" do
      result = StaticArray(UInt8, 6).new(0_u8)
      Hex.decode_to_slice("666f6f626172", result.to_slice)
      result.should eq(StaticArray[0x66, 0x6f, 0x6f, 0x62, 0x61, 0x72])
    end

    it "rejects mismatched length" do
      result = StaticArray(UInt8, 5).new(0_u8)
      expect_raises(Hex::FromHexError, "Invalid string length") do
        Hex.decode_to_slice("666f6f626172", result.to_slice)
      end
    end
  end

  describe "to_hex" do
    it "encodes array to hex" do
      arr = Bytes[0x66, 0x6f, 0x6f, 0x62, 0x61, 0x72]
      arr.encode_hex.should eq("666f6f626172")
      arr.encode_hex_upper.should eq("666F6F626172")
    end
  end

  describe "unsized to_hex" do
    it "encodes string to hex" do
      s = "Hello, world!"
      s.encode_hex.should eq("48656c6c6f2c20776f726c6421")
    end
  end

  describe "FromHexError display" do
    it "formats InvalidHexCharacter with escaped chars" do
      err = Hex::FromHexError.new(Hex::FromHexError::Kind::InvalidHexCharacter, '\n', 5)
      err.message.should eq("Invalid character '\\n' at position 5")
    end

    it "formats OddLength" do
      err = Hex::FromHexError.new(Hex::FromHexError::Kind::OddLength)
      err.message.should eq("Odd number of digits")
    end

    it "formats InvalidStringLength" do
      err = Hex::FromHexError.new(Hex::FromHexError::Kind::InvalidStringLength)
      err.message.should eq("Invalid string length")
    end
  end

  describe "decode_in_slice" do
    it "decodes in place" do
      mut = "6b697769".to_slice.dup
      Hex.decode_in_slice(mut)
      mut[0, 4].should eq("kiwi".to_slice)
    end

    it "rejects odd length" do
      mut = Slice(UInt8).new(3, 0_u8)
      expect_raises(Hex::FromHexError, "Odd number of digits") do
        Hex.decode_in_slice(mut)
      end
    end
  end
end
