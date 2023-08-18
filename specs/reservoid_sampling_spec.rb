require_relative "../lib/reservoir_sampling"

describe ReservoirSampling do
  describe "#visit" do
    it "returns the correct sample size" do
      sample_size = 10
      rs = ReservoirSampling.new(sample_size)
      100.times do |i|
        rs.visit(i)
      end
      expect(rs.samples.size).to eq(sample_size)
    end

    it "samples uniformly" do
      rs = ReservoirSampling.new(1000)
      20_000.times { |i| rs.visit(i) }
      avg = 10_000
      acceptable_error = avg / Math.sqrt(rs.sample_size)
      expect(rs.samples.sum / rs.sample_size).to be_between(avg - acceptable_error, avg + acceptable_error)
    end

    it "samples uniformly 2" do
      rs = ReservoirSampling.new(1000)
      5_000.times { |i| rs.visit(0) }
      5_000.times { |i| rs.visit(1000) }
      avg = 500
      acceptable_error = avg / Math.sqrt(rs.sample_size)
      expect(rs.samples.sum / rs.sample_size).to be_between(avg - acceptable_error, avg + acceptable_error)
    end
  end
end
