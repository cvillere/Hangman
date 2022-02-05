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
      game_state
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

  def deserialize_game(selection)
    restarted_game = Dir['./saved_games/*'][selection]
    while Dir['./saved_games/*'].include?(restarted_game) == false
      puts 'That saved game does not exist. Please try another entry.'
      player_selection = gets.chomp
      restarted_game = Dir['./saved_games/*'][player_selection]
    end
    old_game = File.open(restarted_game, 'r') { YAML.load_file(restarted_game.to_s) }
    old_game[0].display_correct_letters
  end

  def choose_deser_game
    (Dir['./saved_games/*']).each_with_index { |h, i| puts "Game Number(#{i + 1}) -- #{h}" }
    puts 'Select Game Number.'
    game_num = gets.chomp.to_i
    selected_game = game_num - 1
    deserialize_game(selected_game) if game_num.between?(1, Dir['./saved_games/*'].length)
    puts 'invalid selection' unless game_num.between?(1, Dir['./saved_games/*'].length)
    choose_deser_game
  end

  def choose_previous_game
    generate_random_word unless Dir.exist?('./saved_games')
    puts 'Would you like to restart a game? Enter 1 for yes and 2 for no'
    user_choice = gets.chomp
    if user_choice == '1'
      choose_deser_game
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