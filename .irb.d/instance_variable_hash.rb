class Object
  def iv_hash(obj=self)
    obj.instance_variables.inject({}){ |h, name| h[name] = obj.instance_variable_get(name); h }
  end
end
