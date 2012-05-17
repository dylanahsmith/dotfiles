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

def set_term_title(title=nil)
  if title.nil?
    title = Dir.pwd
    if title.starts_with(Dir.home + '/') || title == Dir.home
      title = title[Dir.home.size..-1]
    end
  end
  system("printf", '\033];' + title + '\a')
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

    set_term_title
  end
end
