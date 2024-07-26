require "yaml"
require_relative "text_content"
class Game
  include TextContent

  MAX_ATTEMPTS = 7
  SAVE_DIRECTORY = 'game_saves'

  def initialize
    @secret_word = generate_secret_word
    @guessed_letters = { correct: [], incorrect: [] }
    @attempts_left = MAX_ATTEMPTS
  end

  def start 
    loop do
      display_game_state
      letter = guess_letter
      if letter == 'save'
        save_game
        break
      end  
      update_game_state!(letter)
      if word_guessed?
        show_game_result(true, @secret_word)
        break
      elsif @attempts_left.zero?
        show_game_result(false, @secret_word)
        break
      end
    end
  end


  def self.start
    explain_the_game
    puts "1. New Game"
    puts "2. Load Game"
    choice = gets.chomp
    return start unless choice.between?('1','2')
    game = if choice == '2'
            puts Dir.entries("#{SAVE_DIRECTORY}")
            print "Enter the saved game filename: "
            load_game(gets.chomp)
          else
            self.new
          end
    game.start
  end

  def self.load_game(filename)
    if File.exist?("#{SAVE_DIRECTORY}/#{filename}")
      YAML.safe_load(File.read("#{SAVE_DIRECTORY}/#{filename}"), permitted_classes: [Symbol, self])
    else
      puts "Starting a new game."
      new
    end
  end 
  
  def self.explain_the_game
    puts <<~HEREDOC
      Welcome to Hangman!

      The objective of the game is to guess the secret word before the hangman is fully drawn.

      Rules:
      1. The computer will randomly select a secret word.
      2. You will see a series of underscores representing the letters in the word.
      3. Your task is to guess the letters in the word one at a time.
      4. Each time you guess a letter correctly, the corresponding underscores will be replaced with that letter.
      5. If you guess a letter that is not in the word, a part of the hangman will be drawn.
      6. You have a limited number of incorrect guesses before the hangman is fully drawn.
      7. The game ends when you either guess the entire word correctly or the hangman is fully drawn.

      Your goal is to crack the secret code before the man gets hanged. Good luck!
    HEREDOC
  end

  private

  def word_list
    filename = "google-10000-english-no-swears.txt"
    File.readlines(filename).map(&:chomp)
  end

  def generate_secret_word
    word_list.select { |word| word.length.between?(5, 12) }.sample
  end

  def guess_letter
    print "\nEnter a letter (a-z) or 'save' to save the game: "
    input = gets.chomp.downcase
    return 'save' if input == 'save'
    return guess_letter unless input.match?(/\A[a-z]\z/)
    return guess_letter if @guessed_letters.values.flatten.include?(input)
    input
  end

  def update_game_state!(letter)
    if @secret_word.include? letter
      @guessed_letters[:correct] << letter
      puts "Good guess!"
    else
      @guessed_letters[:incorrect] << letter
      @attempts_left -= 1
      puts "Incorrect guess!"
    end
  end

  def current_progress
    @secret_word.chars.map { |char| @guessed_letters[:correct].include?(char) ? char : '_' }
  end

  def word_guessed?
    current_progress.join == @secret_word 
  end

  def save_game
    Dir.mkdir(SAVE_DIRECTORY) unless Dir.exist?(SAVE_DIRECTORY)
    filename = "#{SAVE_DIRECTORY}/hangman_#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.yaml"
    File.open(filename, 'w') { |file| file.write(YAML.dump(self)) }
    puts ("Game saved to #{filename}")
  end

  def display_game_state
    progress = current_progress
    incorrect_guesses = @guessed_letters[:incorrect]
    show_game_info(progress, incorrect_guesses, @attempts_left)
  end
end
