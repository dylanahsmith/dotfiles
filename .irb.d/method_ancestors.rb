class Module
  def instance_method_ancestors(method_name)
    ancestors.compact.map do |klass|
      method = begin
        klass.instance_method(method_name)
      rescue NameError
        nil
      end
      method && method.owner == klass ? method : nil
    end.compact
  end

  def instance_method_source_locations(method_name)
    instance_method_ancestors(method_name).map{ |m| m.source_location.join(':') }
  end
end

class Object
  def method_ancestors(method_name)
    singleton_class.instance_method_ancestors(method_name).map{ |m| m.bind(self) }
  end

  def method_source_locations(method_name)
    method_ancestors(method_name).map{ |m| m.source_location.join(':') }
  end
end
