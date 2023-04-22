require_relative "word.rb"
require "yaml"

class Game
  attr_accessor :random_word, :tries, :guesses, :guessed_words

  def initialize
    @random_word = Word.new.word
    @tries = 6
    @guesses = String.new
    @guessed_words = "_" * random_word.length
  end

  def intro
    puts "Let's play a hangman game! You can write 'load' to load a file or press enter to start a new game!"
    input = gets.chomp
    load_game if input == "load"
    play_round
  end

  def infos
    puts "Your guesses: #{guesses}"
    puts "Your tries: #{tries}"
    puts "The word you must guess is: #{guessed_words}"
    puts "You can save by tiping 'save'"
  end

  def play_round
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
      if verify_guess(guess)
        return guess
      elsif guess == "save"
        save_game
      elsif !verify_guess(guess)
        puts "invalid guess!"
        input_guess
      end
    end
  end

  def verify_guess(guess)
    if ("a".."z").include?(guess) && !guesses.include?(guess)
      return true
    end
  end

  def check_guess(guess)
    check = false
    random_word.length.times do |index|
      if random_word[index] == guess
        guessed_words[index] = guess
        check = true
      end
    end
    @tries -= 1 unless check == true
  end

  def win?
    true if guessed_words == random_word
  end

  def save_game
    puts "Add a name to the save file you will create: "
    new_file = gets.chomp
    Dir.mkdir("../saved_games") unless Dir.exists?("../saved_games")
    puts "Saved!"
    File.open("../saved_games/#{new_file}.yml", "w") { |file| YAML.dump([] << self, file) }
    exit
  end

  def load_game
    unless Dir.exists?("../saved_games")
      puts "There are no saved games"
      sleep(1)
      return
    end
    games = saved_games
    puts games
    deserialize(ask_game(games))
  end

  def ask_game(database)
    loop do
      puts "Select the name of the file you wanna load"
      input = gets.chomp
      return input if database.include?(input)
      puts "Incorrect file name."
    end
  end

  def saved_games
    puts "Saved games: "
    Dir["../saved_games/*"].map { |f| f.split("/")[-1].split(".")[0] }
  end

  def deserialize(game)
    yaml = YAML.load_file("../saved_games/#{game}.yml")
    self.secret_word = yaml[0].secret_word
    self.guessed_word = yaml[0].guessed_word
    self.no_of_guesses = yaml[0].no_of_guesses
    self.guesses = yaml[0].guesses
  end
end
