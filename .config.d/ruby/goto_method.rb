class Object
  def g(sym)
    (kind_of?(Class) ? gim(sym) : gm(sym)).goto
  end
  def gm(sym)
    method(sym).goto
  end
  def gim(sym)
    instance_method(sym).goto
  end
end

class Method
  def goto
    file, line = if respond_to?(:source_location)
      source_location
    else
      [__file__, __line__]
    end
    raise(ArgumentError, 'native Method') unless file && line
    system(ENV['EDITOR'] || 'vim', '-n', "+#{line}", file)
  end
end
