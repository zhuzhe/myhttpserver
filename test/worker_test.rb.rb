i = 0

while i < 3
  pid = fork
  if pid
    puts pid
  end
end
