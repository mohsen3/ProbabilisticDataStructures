require_relative "../lib/count_min_sketch"

describe CountMinSketch do
  describe "#count" do
    context "relatively sparse data" do
      it "returns the correct count" do
        sketch = CountMinSketch.new(32, 3)
        sketch.inc("x")
        sketch.inc("x")
        sketch.inc("x")
        sketch.inc("y")
        expect(sketch.count("x")).to eq 3
        expect(sketch.count("y")).to eq 1
        expect(sketch.count("z")).to eq 0
      end
    end

    context "relatively dense data" do
      it "keeps approximately correct count" do
        sketch = CountMinSketch.new(16, 3)
        ('a'..'z').each { |letter| sketch.inc(letter) }
        999.times { sketch.inc("x") }
        999.times { sketch.inc("y") }
        999.times { sketch.inc("z") }

        ('x'..'z').each do |l|
          expect(sketch.count(l)).to be_between(998, 1002)
        end
        ('a'..'w').each do |l|
          expect(sketch.count(l)).to be_between(1, 3)
        end
      end
    end
  end
end
