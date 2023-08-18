# frozen_string_literal: true

require_relative 'hashes'

class CountMinSketch
  def initialize(size, num_hashes)
    # size should be a power of 2 else we may have
    # some bias towards the begging of the bitset
    bits_per_hash = Math.log2(size).ceil
    @hashes = Hashes.new(num_hashes, bits_per_hash)
    @counters = num_hashes.times.map{ Array.new(size) { 0 } }
  end

  def inc(key, by = 1)
    @hashes.hashes(key).each_with_index do |hash, i|
      @counters[i][hash % @counters[i].size] += by
    end
  end

  def count(key)
    @hashes.hashes(key).each_with_index.map do |hash, i|
      @counters[i][hash % @counters[i].size]
    end.min
  end
end
