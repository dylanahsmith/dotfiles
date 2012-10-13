def deep_diff(a, b)
  return nil if a == b
  a = a.dup if a.is_a?(Hash) || a.is_a?(Array)
  b = b.dup if b.is_a?(Hash) || b.is_a?(Array)
  if a.is_a?(Hash) && b.is_a?(Hash)
    (a.keys & b.keys).each do |k|
      d = deep_diff(a[k], b[k])
      if d == nil
        a.delete(k)
        b.delete(k)
      else
        a[k], b[k] = d
      end
    end
  elsif a.is_a?(Array) && b.is_a?(Array)
    [a.size, b.size].min.times do |i|
      d = deep_diff(a[i], b[i])
      a[i], b[i] = d
    end
    if a.size == b.size
      while !a.empty? && a.last == b.last
        a.pop
        b.pop
      end
    end
  end
  [a, b]
end
