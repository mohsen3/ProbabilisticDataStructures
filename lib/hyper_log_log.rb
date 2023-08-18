# frozen_string_literal: true
require 'hashes'

class HyperLogLog
  ALPHA_INF = 1 / (2 * Math.log(2))
  HASH_BITS = 64

  def initialize(num_buckets)
    @buckets = Array.new(num_buckets, 0)
    @hashes = Hashes.new(2, HASH_BITS)
  end

  def add(key)
    hashes = @hashes.hashes(key)
    bucket_index = hashes[0] % @buckets.size
    zeros = HASH_BITS - hashes[1].to_s(2).size + 1
    @buckets[bucket_index] = [zeros, @buckets[bucket_index]].max
  end

  # Count is calculated using the algorithm described in
  # "New cardinality estimation algorithms for HyperLogLog sketches"
  # Otmar Ertl, arXiv:1702.01284
  # Redis uses the same algorithm.
  def count
    m = @buckets.size
    hist = compute_histogram
    z = m * tau((m - hist[HASH_BITS + 1]) / m)
    (HASH_BITS).downto(1) do |j|
      z += hist[j]
      z *= 0.5
    end
    z += m * sigma(hist[0] / (1.0 * m))
    ALPHA_INF * m * m / z
  end

  private def compute_histogram
    hist = [0] * (HASH_BITS + 2)
    @buckets.each do |bucket|
      hist[bucket] += 1
    end
    hist
  end

  private def tau(x)
    return 0.0 if x == 0.0 || x == 1.0
    z_prime = nil
    y = 1.0
    z = 1 - x
    while z_prime != z
      x = Math.sqrt(x)
      z_prime = z
      y *= 0.5
      z -= ((1 - x) ** 2) * y
    end
    z / 3
  end

  private def sigma(x)
    return Float::INFINITY if x == 1.0
    z_prime = nil
    y = 1
    z = x
    while z_prime != z
      x *= x
      z_prime = z
      z += x * y
      y += y
    end
    z
  end
end
