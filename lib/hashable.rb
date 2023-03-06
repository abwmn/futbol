module Hashable
  def nested_hash
    Hash.new { |h, k| h[k] = Hash.new(0) }
  end

  def super_nested_hash
    Hash.new { |h, k| h[k] = Hash.new { |h, k| h[k] = Hash.new(0) } }
  end
end