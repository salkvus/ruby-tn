vowels = %w[а е ё и о у э ю я]
hash_vowels = {}
('а'..'я').each_with_index do |ch, index|
  if vowels.include? ch
    shift = ch <= 'е' ? 0 : 1
    hash_vowels[ch] = index + shift
  end
end
hash_vowels['ё'] = hash_vowels['е'] + 1
p hash_vowels

