[
  'goto_method',
  'less',
  'local_methods',
  'instance_variable_hash',
  'method_inheritence',
  'misc',
  'time',
].each do |modname|
  require File.join(File.dirname(__FILE__), modname)
end
