print"Введите коэффициент a (при x2):"
a = gets.to_f
print"Введите коэффициент b (при x):"
b = gets.to_f
print"Введите коэффициент c (свободный член):"
c = gets.to_f

d = b**2 - 4 * a  c
if a == 0 && b == 0 && c != 0 || d < 0
  abort "D = #{d} Корней нет"
elsif a == 0 && b == 0 && c == 0
  puts "Любое значение является решением этого уравнения (бесконечное множество решений)"
  exit 0
end

if d == 0
  x1 = x2 = -b / (2.0 * a)
  puts "D = #{d} #{x1}"
else
  d_sqrt = Math.sqrt(d)
  x1 = (-b - d_sqrt / (2.0 * a)
  x2 = (-b + d_sqrt / (2.0 * a)
  puts "D = #{d} #{x1} #{x2}"
end
