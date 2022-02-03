module Game_Save

  def game_state
    puts "#{@max_guesses} guesses remaining || incorrect letters guessed: #{@incorrect_letters}"
    puts @correct_letters.join(' ')
  end

  def save_game
    puts 'Enter 1 to save game & 2 to continue playing'
    game_save_resp = gets.chomp
    case game_save_resp
    when '1'
      serialize_game
      puts "game saved!!"
    when '2'
      game_state
      return 
    else
      puts 'Incorrect response.'
      game_state
      save_game
    end
  end

  def serialize_game
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    saved_file = "saved_games/game_#{Time.now}.yaml"
    File.open(saved_file, 'w') { |f| YAML.dump([] << self, f) }
  end

  def deserialize_game
    puts Dir['./saved_games/*']
    chosen_game = gets.chomp
    directory_games = Dir['./saved_games/*']
    while directory_games.include?(chosen_game) == false
      puts 'That saved game does not exist. Please try another entry.'
      chosen_game = gets.chomp
    end
    old_game = File.open(chosen_game, 'r') { YAML.load_file(chosen_game.to_s) }
    old_game[0].display_correct_letters
  end

  def choose_previous_game
    puts 'Would you like to restart a game? Enter 1 for yes and 2 for no'
    user_choice = gets.chomp
    if user_choice == '1'
      deserialize_game
    elsif user_choice == '2'
      generate_random_word
    else
      puts 'incorrect response.'
      choose_previous_game
    end
  end

  def trigger_save_game
    if @max_guesses < 9 || @correct_letters.join.match?(/[a-zA-Z]/)
      save_game
    end
  end

end