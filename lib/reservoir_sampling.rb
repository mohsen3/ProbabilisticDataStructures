# frozen_string_literal: true

class ReservoirSampling
  attr_reader :sample_size, :samples, :visited

  def initialize(sample_size)
    @sample_size = sample_size
    @samples = Array.new(sample_size)
    @visited = 0
  end

  def visit(item)
    if visited < sample_size
      samples[visited] = item
    else
      random_index = rand(visited)
      samples[random_index] = item if random_index < sample_size
    end
    @visited += 1
  end
end
