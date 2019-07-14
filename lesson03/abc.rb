vowels = 'аеёиоуэюя'.split('')
hash_vowels = {}
vowels.each do |ch|
  shift = ch.ord <= 'е'.ord ? 1 : 2
  hash_vowels[ch] = (ch == 'ё' ? 'е'.ord - vowels[0].ord : ch.ord - vowels[0].ord) + shift
end

