require 'json'
require 'time'

class KeyWord
  attr_accessor :key

  def initialize(min_length, max_length)
    # @type [String]
    @key = select_word(min_length, max_length)
    @display = ''.rjust(@key.length, '-')
    @wrong_guesses = []
  end

  def to_json(*_args)
    JSON.dump({
                key: @key,
                display: @display,
                wrong_guesses: @wrong_guesses
              })
  end

  def guess
    # @type [String]
    show
    guess = get_input
    return if @saved

    puts "you guessed #{guess}"
    compare_guess(guess)
  end

  def game_over?
    # if 10 guesses is reached the player loses
    if @saved
      puts 'Game saved successfully.'
      return true
    end

    if @wrong_guesses.length == 10
      puts "You are out of guesses. The words was \"#{@key}\""
      return true
    end

    if @display.count('-').zero?
      checkmark = "\u2713"
      puts "\n#{@display} #{checkmark.encode('utf-8')}"
      puts "You win!"
      true
    else
      false
    end
  end

  private

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
    puts "#{10 - @wrong_guesses.length} guesses left."
    puts "Please guess a character, or type \"save\" to save the current game:\n" unless @wrong_guesses.length == 10 || @display.count('-').zero?
  end

  def compare_guess(guess)
    @wrong_guesses.push(guess) if @key.index(guess).nil?
    index = 0
    @key.each_char do |char|
      @display[index] = guess if char == guess

      index += 1
    end
  end

  def valid?(input)
    if @wrong_guesses.include?(input)
      false
    elsif @display.include?(input)
      false
    elsif input.between?('a', 'z')
      true
    else
      false
    end
  end

  def get_input
    input = gets
    input = input.chomp.downcase
    if input == 'save'
      save_game

    else
      input = input.chr
      until valid?(input)
        if @wrong_guesses.include?(input)
          puts "Duplicate input, you have already guessed \"#{input}\" incorrectly. Please guess another character:"
        elsif @display.include?(input)
          puts "You have already guessed \"#{input}\" correctly. Please guess another character:"
        else
          puts "Invalid input \"#{input}\". Please enter a single charcter:"
        end

        input = gets
        input = input.chomp.downcase.chr
      end
      input
    end
  end

  def save_game
    @saved = true
    Dir.mkdir('save') unless Dir.exist?('save')
    save_file = File.open('save/saved_game.txt', 'w')
    save_file.puts to_json
    save_file.close
  end
end

class LoadGame < KeyWord
  def initialize(data)
    @key = data['key']
    @display = data['display']
    @wrong_guesses = data['wrong_guesses']
  end

  def self.from_json(string)
    data = JSON.load string
    new(data)
  end
end
# placeholder test

puts "Press 1 to play a new game or Press 2 to load your last saved game:"
game_mode = gets.chomp.to_i
case game_mode
when 1
  key_word = KeyWord.new(5, 12)
  key_word.guess until key_word.game_over?
when 2
  load_file = File.open("save/saved_game.txt","r")
  key_word = LoadGame.from_json(load_file)
  key_word.guess until key_word.game_over?
else
  puts "else"
end

