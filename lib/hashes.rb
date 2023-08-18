# frozen_string_literal: true

require 'digest'

# calculates multiple hash values for a given key
# by splitting the result of an md5 hash function.
class Hashes
  TOTAL_BITS = Digest::MD5.new.size * 8

  def initialize(num_hashes, bits_per_hash)
    @num_hashes = num_hashes.to_i
    @bits_per_hash = bits_per_hash.to_i
    bits_required = @num_hashes * @bits_per_hash
    if !(1..TOTAL_BITS).include?(bits_required)
      raise ArgumentError, "supports 1-#{TOTAL_BITS} bits, requested #{bits_required}"
    end
  end

  def hashes(key)
    Digest::MD5
      .hexdigest(key)
      .to_i(16)
      .to_s(2)
      .rjust(TOTAL_BITS, '0')
      .scan(/.{#{@bits_per_hash}}/)
      .take(@num_hashes)
      .map { |bits| bits.to_i(2) }
  end
end
