class Object

  def locate_method(meth)
    self.class.ancestors.select{|klass|klass.instance_methods.map(&:to_s).include?(meth.to_s)}
  end

  def method_inheritance
    meths = methods
    table = { }
    self.class.ancestors.each do |klass|
      table[klass.name] = []
      meths.each do |meth|
        table[klass.name] << meths.delete(meth) if klass.instance_methods.include?(meth)
      end
    end
    table
  end

end
