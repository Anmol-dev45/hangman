require_relative "text_content"
require_relative "serializable"
class Game
  include TextContent
  include Serializable

  def initialize
    explain_the_game
    if option_to_play_new_game
      @secret_word = generate_secret_word
      @guessed_letters = {
        "correct_letters" => [],
        "incorrect_letters" => []
      }
      @attempts_left = 7
    else
      update_to_previous_game_state!
    end
  end

  def start
    loop do
      play_a_round!
      if word_guessed?
        show_game_result(true, @secret_word)
        break
      elsif @attempts_left.zero?
        show_game_result(false, @secret_word)
        break
      end
      next unless option_to_save?

      save_game_state
      puts "Your game is saved!"
      break
    end
  end

  private

  def word_list
    filename = "google-10000-english-no-swears.txt"
    File.readlines(filename).map(&:chomp)
  end

  def generate_secret_word
    word_list.select { |word| word.length.between?(5, 12) }.sample
  end

  def play_a_round!
    progress = current_progress
    incorrect_guesses = @guessed_letters["incorrect_letters"]
    show_game_info(progress, incorrect_guesses, @attempts_left)
    letter = guess_letter
    update_guessed_letters! letter
  end

  def guess_letter
    print "Enter a letter from range a to z: "
    letter = gets.chomp.downcase
    guessed_letters = @guessed_letters.values.flatten
    unless letter.match?(/\A[a-z]*\z/)
      puts "#{letter} is not valid!"
      return guess_letter
    end
    if guessed_letters.include? letter
      puts "#{letter} has already been entered!"
      return guess_letter
    end
    letter
  end

  def update_guessed_letters!(letter)
    if @secret_word.include? letter
      @guessed_letters["correct_letters"] << letter
    else
      @guessed_letters["incorrect_letters"] << letter
      @attempts_left -= 1
      puts "You guessed the wrong letter!\n"
    end
  end

  def current_progress
    progress = []
    @secret_word.each_char do |char|
      progress << if  @guessed_letters["correct_letters"].include?(char)
                    char
                  else
                    "_"
                  end
    end
    progress
  end

  def word_guessed?
    !current_progress.include?("_")
  end

  def option_to_save?
    puts "You can save the game or play.\n1.\tSave\n2.\tContinue"
    option = gets.chomp.to_i
    unless option.between?(1, 2)
      puts "#{option} is not valid!"
      return option_to_save?
    end
    option == 1
  end

  def save_game_state
    state = serialize
    filename = "hangman_game_state"
    File.open(filename, "w") do |f|
      f.puts state
    end
  end

  def option_to_play_new_game
    if File.exist? "hangman_game_state"
      puts "Do you mant to resume your previous game or start new game?\n1.\tResume previous game\n2.\tStart new game"
      option = gets.to_i
      unless option.between?(1, 2)
        puts "#{option} is not valid!"
        return option_to_play_new_game
      end
      return option == 2
    end
    true
  end

  def update_to_previous_game_state!
    state = File.open("hangman_game_state").gets.chomp
    unserialize state
  end
end
