def less(*args)
  IO.popen('less -R', 'w') { |io| io.puts(*args) }
end
