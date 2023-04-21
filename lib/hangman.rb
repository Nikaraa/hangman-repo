require_relative "word.rb"

class Hangman
  attr_accessor :random_word, :tries, :guesses, :guessed_words

  def initialize
    @random_word = Word.new.word
    @tries = 6
    @guesses = ""
    @guessed_words = "_ " * random_word.length
  end
end
