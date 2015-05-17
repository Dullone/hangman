require "io/console"
require "yaml"

class Hangman
  GUESES = 6
  FILENAME = "save.yml"
  def initialize (guesses = GUESES)
    @guesses = guesses
    @letter_board = []
    @game_over = false
    @word = ""
  end

  def start_game
    set_up_game
    run_game
  end

  def continue_game
    run_game
  end

  private
  def set_up_game
    @game_over = false

    words = File.readlines("5desk.txt")
    @word = words[Random.rand words.length].chomp.strip.downcase
    set_up_letter_board
  end

  def run_game
    while !@game_over do
      draw_board
      pick_letter
      if winner?
        puts "You won!"
        @game_over = true
      end
    end
    puts "The word was: #{@word}"
  end

  def draw_board
    puts @letter_board.join(" ")
  end

  def pick_letter
    print "Pick a letter: "
    letter = gets.chomp.downcase
    #letter = STDIN.getch #alternate, not as smooth
    if letter == "save"
      save_game
      puts "Game saved, exiting."
      exit
    end
    if check_letter letter
      puts "letter found!"
      reveal_letter letter
    else
      @guesses -= 1
      puts "Incorrect! #{@guesses} guesses left"
      if @guesses == 0
        @game_over = true
      end
    end
  end

  def winner?
    #if all letters are revealed, then no _ will be present
    !@letter_board.include? "_"
  end

  def reveal_letter(letter)
    index = 0
    @word.each_char do |c|
      if c == letter
        @letter_board[index] = c
      end
      index += 1
    end
  end

  def check_letter (letter)
    @word.include? letter
  end

  def set_up_letter_board
    @letter_board = Array.new(@word.length, "_")
  end

  def save_game
    file = File.new(FILENAME, "w")
    file.puts YAML::dump(self)
    file.close
  end
end

print "Load saved game? (y/n): "
answer = gets.chomp.downcase
if answer == "y"
  yaml_string = File.read(Hangman::FILENAME)
  hangman = YAML::load(yaml_string)
  hangman.continue_game
else
  hangman = Hangman.new
  hangman.start_game
end