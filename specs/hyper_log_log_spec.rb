require_relative "../lib/hyper_log_log"
require 'securerandom'

describe HyperLogLog do
  describe "#count" do
    def rnd
      rand.to_s
    end

    def acceptable_error_bound(n)
      err_percentage = 0.02
      [n - err_percentage * n, n + err_percentage * n]
    end

    it "doesn't have a high error rate" do
      [10, 100, 1000, 10_000, 100_000].each do |n|
        hll = HyperLogLog.new(12000)
        n.times do
          hll.add(rnd)
        end
        expect(hll.count).to be_between(*acceptable_error_bound(n))
      end
    end
  end
end
