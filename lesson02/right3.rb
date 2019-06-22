print"Введите 1-ую сторону треугольника:"
a = gets.to_f
print"Введите 2-ую сторону треугольника:"
b = gets.to_f
print"Введите 3-ую сторону треугольника:"
c = gets.to_f

# Проверка условия существования треугольника
if a + b <= c || a + c <= b || b + c <= a
  abort "Такого треугольника не существует"
end

#  Сортируем стороны по возрастанию
a, b, c = [a, b, c].sort!

is_right = (c**2 == a**2 + b**2)
is_isosceles = a == b || b == c || a == c
is_equilateral = a == b && b == c

puts "Треугольник прямоугольный" if is_right
puts "Треугольник равнобедренный" if is_isosceles && !is_equilateral
puts "Треугольник равнобедренный и равносторонний, но не прямоугольный" if is_equilateral

	

