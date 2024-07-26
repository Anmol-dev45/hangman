module TextContent
  def explain_the_game
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

  def show_current_progress(progress)
    puts "Current progress: #{progress.join(' ')}"
  end

  def show_incorrect_guesses(incorrect_guesses)
    puts "Incorrect guesses: #{incorrect_guesses.join(', ')}"
  end

  def show_remaining_attempts(attempts_left)
    puts "Remaining attempts: #{attempts_left}"
  end

  def show_game_result(success, word)
    if success
      puts "Congratulations! You've guessed the word: #{word}"
    else
      puts "Game Over! The correct word was: #{word}"
    end
  end

  def show_game_info(progress, incorrect_guesses, attempts_left)
    show_current_progress progress
    show_incorrect_guesses incorrect_guesses
    show_remaining_attempts attempts_left
  end
end
