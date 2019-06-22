print"Введите свое имя:"
user_name = gets.chomp
print "Введите свой рост:"
user_height = gets.to_i

opt_height = user_height - 110
if opt_height >= 0
  puts "#{user_name} ваш оптимальный вес #{opt_height}"
else
  puts "Ваш вес уже оптимальный"
end
