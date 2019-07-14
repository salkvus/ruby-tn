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
days_num = day;
(1...month).each do |i|
  days_num +=
    case i
    when 1, 3, 5, 7, 8, 10, 12
      31
    when 4, 6, 9, 11
      30
    when 2
      if is_leap
        29
      else
        28
      end
    end
end
p days_num
