module Game_Save

  def save_game
    puts 'Would you like to save the game? Enter 1 for yes & 2 for no'
    game_save_resp = gets.chomp
    case game_save_resp
    when '1'
      serialize_game
      puts "game saved!!"
    when '2'
      return
    else
      puts 'Incorrect response. Please enter either a 1 to save or 2 to continue game'
      save_game
    end
  end

  def serialize_game
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    saved_file = "saved_games/game_#{Time.now}.yaml"
    File.open(saved_file, 'w') { |f| YAML.dump([] << self, f) }
  end

  def deserialize_game
    puts 'Would you like to restart a game?'
    puts Dir['./saved_games/*']
    directory_games = Dir['./saved_games/*']
    chosen_game = gets.chomp
    while directory_games.include?(chosen_game) == false
      puts 'That saved game does not exist. Please try another entry.'
      chosen_game = gets.chomp
    end
    old_game = File.open(chosen_game, 'r') { YAML.load_file(chosen_game.to_s) }
    old_game[0].display_correct_letters
  end

  def trigger_save_game
    if @max_guesses < 9 || @correct_letters.join.match?(/[a-zA-Z]/)
      save_game
    end
  end

end