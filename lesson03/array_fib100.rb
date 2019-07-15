ary_fib = [0, 1]
next_number = 1
while next_number <= 100
  ary_fib << next_number
  next_number = ary_fib[-1] + ary_fib[-2]
end
p ary_fib

