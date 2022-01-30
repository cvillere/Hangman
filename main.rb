# frozen_string_literal: true
require 'yaml'
require 'Time'

# Main class to play hangman game
class Hangman

  attr_accessor :correct_letters, :incorrect_letters, :word, :max_guesses, :word_array

  def initialize
    @correct_letters = []
    @incorrect_letters = []
    @word = ''
    @word_array = ''
    @max_guesses = 9
  end

  def generate_random_word
    all_words = File.read('./5desk.txt').split
    @word = all_words.select { |n| n.length >= 5 && n.length <= 12 }.sample(1)
    create_word_array.each { @correct_letters.push('_') }
    display_correct_letters
  end

  def create_word_array
    @word_array = @word.join('').split('')
  end

  def display_correct_letters
    determine_game_result
    p "You have #{@max_guesses} guesses remaining"
    puts "incorrect letters guessed: #{@incorrect_letters}"
    p @correct_letters.join(' ')
    trigger_save_game
    puts '-------------------------------------------------'
    puts 'What letter do you guess is a part of the word?'
    player_guess = gets.chomp.downcase
    deal_with_guess(player_guess)
  end

  def update_correct_guess(player_guess)
    @word_array.each_with_index do |n, index|
      if n == player_guess
        @correct_letters[index] = player_guess
      end
    end
    display_correct_letters
  end

  def pushing_incorrect_letters(player_guess)
    if @incorrect_letters.include?(player_guess) == false
      @incorrect_letters.push(player_guess)
      @max_guesses -= 1
      display_correct_letters
    end
  end

  def play_another_game
    play_again = gets.chomp
    while play_again != '1' || play_again != '2'
      if play_again == '1'
        Hangman.new.generate_random_word
      elsif play_again == '2'
        exit
      else
        puts 'Incorrect entry. Please enter 1 to continue playing or 2 to stop playing'
        play_again = gets.chomp
      end
    end
  end

  def determine_game_result
    if @max_guesses.positive? == true && @correct_letters.include?('_') == false
      puts "#{@correct_letters.join(' ')}  is...#{@correct_letters.join('').upcase}!!"
      puts 'You have won the game! Would you like to play again? 1 for Yes & 2 for No'
      play_another_game
    end
    if @max_guesses.zero? == true && @correct_letters.include?('_') == true
      puts 'You have lost the game! Would you like to play again? 1 for Yes & 2 for No'
      play_another_game
    end
  end

  def deal_with_guess(player_guess)
    until @max_guesses.zero?
      if @word_array.include?(player_guess) == false
        pushing_incorrect_letters(player_guess)
      else
        update_correct_guess(player_guess)
      end
    end
  end

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

Hangman.new.generate_random_word
