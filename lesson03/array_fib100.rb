ary_fib = [0, 1]
fib1, fib2 = ary_fib[0], ary_fib[1]
while fib1 + fib2 <= 100
  ary_fib << fib1 + fib2
  fib1, fib2 = fib2, ary_fib.last
end
p ary_fib

