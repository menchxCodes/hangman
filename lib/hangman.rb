
class KeyWord
  attr_accessor :key

  def initialize(min_length, max_length)
    # @type [String]
    @key = select_word(min_length, max_length)
    @display = ''.rjust(@key.length, '-')
    @wrong_guesses = []
  end

  # establish 5-12 character words dictionary and select a random word
  def select_word(min_length, max_length)
    word_dictionary = File.open('word_dictionary.txt', 'r')
    words = []
    word_dictionary.readlines.each do |line|
      words.push(line.chomp) if line.chomp.length >= min_length && line.chomp.length <= max_length
    end

    words.sample
  end

  # draw placeholder for answer
  def show
    puts "\n#{@display}   #{@wrong_guesses.join(' ')}"
    puts "#{10-@wrong_guesses.length} guesses left."
    puts "Please guess a character:\n" unless @wrong_guesses.length == 10
  end

  def guess(char)
    # @type [String]
    char = char.chomp
    puts "you guessed #{char}"
    compare_guess(char)
    show
  end

  def compare_guess(guess)
    @wrong_guesses.push(guess) if @key.index(guess).nil?
    index = 0
    @key.each_char do |char|
      @display[index] = guess if char == guess

      index += 1
    end
  end

  def game_over?
    if @wrong_guesses.length == 10
      puts "You are out of guesses. The words was \"#{@key}\""
      return true
    end

    if @display.count('-').zero?
      puts 'You win!'
      true
    else
      false
    end
  end
end


# take player input and validate it
# update placeholder with answer
# if 10 guesses is reached the player loses

# word = "recreational"
key_word = KeyWord.new(5,12)
puts "#{key_word.key} #{key_word.key.length} #{key_word.key.class}"
key_word.show
until key_word.game_over?
  key_word.guess(gets)
end
