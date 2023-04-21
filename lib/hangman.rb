require_relative "word.rb"

class Hangman
  attr_accessor :random_word, :tries, :guesses, :guessed_words

  def initialize
    @random_word = Word.new.word
    @tries = 6
    @guesses = String.new
    @guessed_words = "_" * random_word.length
  end

  def infos
    puts "Your guesses: #{guesses}"
    puts "Your tries: #{tries}"
    puts "The word you must guess is: #{guessed_words}"
  end

  def play_round
    puts "Let's play a Hangman game!"
    until @tries == 0
      input = input_guess
      guesses << input + " "
      check_guess(input)
      break if win?
    end
    game_over
  end

  def game_over
    if guessed_words == random_word
      puts "You won the game"
    else
      puts "You lost the game! The word was #{random_word}"
    end
  end

  def input_guess
    infos
    loop do
      puts "Make your guess [a-z]"
      guess = gets.chomp.downcase
      return guess if verify_guess(guess)
      puts "Error, you can only guess a word or the entire one,\nand you can't use a word you already used"
    end
  end

  def verify_guess(guess)
    if ("a".."z").include?(guess) && !guesses.include?(guess)
      return true
    end
  end

  def check_guess(guess)
    random_word.length.times do |index|
      if random_word[index] == guess
        guessed_words[index] = guess
      end
    end
    @tries -= 1
  end

  def win?
    true if guessed_words == random_word
  end
end
