require_relative "../lib/hashes"

describe Hashes do
  describe "#initialize" do
    it "raises an error if the number of bits is not between 1 and 128" do
      expect { Hashes.new(1, 0) }.to raise_error(ArgumentError)
      expect { Hashes.new(1, 129) }.to raise_error(ArgumentError)
      expect { Hashes.new(-1, 8) }.to raise_error(ArgumentError)
    end
  end

  describe "#hashes" do
    it "returns an array of hashes" do
      hashes = Hashes.new(3, 8).hashes("key")
      expect(hashes).to be_an(Array)
      expect(hashes.length).to eq(3)
      hashes.each do |hash|
        expect(hash).to be_an(Integer)
        expect(hash).to be_between(0, 255)
      end
    end

    it "returns the same hashes for the same key" do
      hashes1 = Hashes.new(3, 8).hashes("keyx")
      hashes2 = Hashes.new(3, 8).hashes("keyx")
      expect(hashes1).to eq(hashes2)
    end
  end
end
