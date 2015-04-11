[
  'deep_diff',
  'goto_method',
  'instance_variable_hash',
  'less',
  'local_methods',
  'method_ancestors',
  'misc',
  'time',
].each do |modname|
  require File.join(File.dirname(__FILE__), modname)
end
