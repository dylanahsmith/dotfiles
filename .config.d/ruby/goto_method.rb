class Object
  def g(sym)
    kind_of?(Class) ? gim(sym) : gm(sym)
  end
  def gm(sym)
    __goto_method(method(sym))
  end
  def gim(sym)
    __goto_method(instance_method(sym))
  end
  def __goto_method(x)
    file, line = if x.respond_to?(:source_location)
      x.source_location
    else
      [x.__file__, x.__line__]
    end
    system(ENV['EDITOR'] || 'vim', '-n', "+#{line}", file)
  end
end

