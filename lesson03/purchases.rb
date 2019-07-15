cart = Hash.new
loop do
  print "Введите товар: "
  product = gets.chomp
  
  break if product == 'stop'

  print "Введите цену: "
  price = gets.to_f
  print "Введите количество: "
  quantity = gets.to_f

  cart[product] = { price: price, quantity: quantity }
end

cart.each do |product, item|
  item_sum = item[:price] * item[:quantity]
  puts "#{product}  #{item} Итого по товару: #{item_sum}"
end
total = cart.collect { |_, item| item[:price] * item[:quantity] }.reduce(:+)
puts "Общий итого: #{total}"
