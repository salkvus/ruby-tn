def leap_year?(year)
  is_div_4 = (year % 4).zero?
  is_div_100 = (year % 100).zero?
  is_div_400 = (year % 400).zero?
  return is_div_400 || (is_div_4 && !is_div_100)
end

print "Введите число: "
day = gets.to_i
print "Введите месяц: "
month = gets.to_i
print "Введите год: "
year = gets.to_i

is_leap = leap_year? year
month_days = [31, (is_leap ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
days_num = month_days.take(month - 1).reduce(:+) + day
p days_num
