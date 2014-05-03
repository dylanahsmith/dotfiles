def jsonpretty(input)
  JSON.pretty_generate(JSON.parse(input))
end
