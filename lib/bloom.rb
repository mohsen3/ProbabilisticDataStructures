# frozen_string_literal: true

require 'bitset'
require_relative 'hashes'

class Bloom
  def initialize(size, num_hashes)
    # size should be a power of 2 else we may have
    # some bias towards the begging of the bitset
    bits_per_hash = Math.log2(size).ceil
    @hashes = Hashes.new(num_hashes, bits_per_hash)
    @bit_arrays = num_hashes.times.map{ Bitset.new(size) }
  end

  def add(key)
    @hashes.hashes(key).each_with_index do |hash, i|
      @bit_arrays[i].set(hash % @bit_arrays[i].size)
    end
  end

  def include?(key)
    # include? returns either certainly no (false) or probably yes (true)
    @hashes.hashes(key).each_with_index.all? do |hash, i|
      @bit_arrays[i][hash % @bit_arrays[i].size]
    end
  end
end
