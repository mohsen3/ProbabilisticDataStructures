require_relative "../lib/bloom"

describe Bloom do
  describe "#include" do
    it "returns false if the key has not been added" do
      bloom = Bloom.new(1024, 3)
      expect(bloom.include?("key")).to be false
    end

    it "returns true if the key has been added" do
      bloom = Bloom.new(1024, 3)
      bloom.add("key")
      expect(bloom.include?("key")).to be true
    end

    it "doesn't have a high false positive rate" do
      bloom = Bloom.new(2048, 5)
      1000.times { |i| bloom.add(i.to_s) }
      false_positives = 1000.times.count do |i|
        bloom.include?((1000 + i).to_s)
      end
      expect(false_positives).to be <= 15
    end

    it "has zero false negatives rate" do
      bloom = Bloom.new(2048, 5)
      1000.times { |i| bloom.add(i.to_s) }
      false_negatives = 1000.times.count do |i|
        !bloom.include?(i.to_s)
      end
      expect(false_negatives).to eq 0
    end
  end
end
