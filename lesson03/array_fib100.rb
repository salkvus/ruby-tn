ary_fib = Array.new(100)
(0..100).each do |i|
  if i <= 1
    ary_fib[i] = i
  else
    ary_fib[i] = ary_fib[i - 1] + ary_fib[i - 2]
  end
end

