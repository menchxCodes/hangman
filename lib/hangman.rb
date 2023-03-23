# establish 5-12 character words dictionary and select a random word
def select_word(min_length, max_length)
  word_dictionary = File.open('word_dictionary.txt', 'r')
  words = []
  word_dictionary.readlines.each do |line|
    words.push(line.chomp) if line.chomp.length >= min_length && line.chomp.length <= max_length
  end

  words.sample.chomp
end
# draw placeholder for answer
# take player input and validate it
# update placeholder with answer
# if 10 guesses is reached the player loses

# word = select_word(5, 12)
word = "balanced"
puts "#{word} #{word.length} #{word.class}"
