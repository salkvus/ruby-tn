cart = Hash.new
loop do
  print "Введите товар: "
  product = gets.chomp
  
  break if product == 'stop'

  print "Введите цену: "
  price = gets.to_f
  print "Введите количество: "
  quantity = gets.to_f

  if cart.key?(product)
    cart[product][price] = quantity
  else
    cart[product] = { price => quantity }
  end
end

total = 0
cart.each do |product, item|
  item_sum = item.collect { |price, quantity| price * quantity }.reduce(:+)
  puts "#{product}  #{item} Итого по товару: #{item_sum}"
  total += item_sum
end
puts "Общий итого: #{total}"
