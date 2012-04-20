class Object
  def local_methods(obj=self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
end
