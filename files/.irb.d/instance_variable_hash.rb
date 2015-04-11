class Object
  def iv_hash(obj=self)
    obj.super_send(Object, :instance_variables).each_with_object({}) do |name, hash|
      hash[name] = obj.super_send(Object, :instance_variable_get, name)
    end
  end
end
