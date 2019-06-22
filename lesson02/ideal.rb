print"Введите свое имя:"
user_name = gets.chomp
print "Введите свой рост:"
user_height = gets.chomp.to_i

if user_height - 110 >= 0
  puts "#{user_name} ваш оптимальный вес #{user_height - 110}"
else
  puts "Ваш вес уже оптимальный"
end
