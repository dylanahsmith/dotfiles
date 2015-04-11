class Object
  def local_methods(obj=self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end

  def super_send(klass, method_name, *args, &block)
    klass.instance_method(method_name).bind(self).call(*args, &block)
  end
end
