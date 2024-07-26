module TextContent
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
