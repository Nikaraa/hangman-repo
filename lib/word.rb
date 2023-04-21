class Word
  attr_reader :word

  def initialize
    @word = choose_word
  end

  def choose_word
    database = File.readlines("../google-10000-english-no-swears.txt")
    loop do
      word = database[rand(database.length)]
      return word if word.length >= 5 && word.length <= 12
    end
  end
end
