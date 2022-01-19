# frozen_string_literal: true

# Project to build the Hangman game for Odin Project

=begin
###Pre-writing for Hangman
VERBS
1) Load in 5desk.txt file
2) Randomly select secret word between 5 and 12 characters long from file
3) Make guess of a letter (case insensitive)
---puts phrase to ask player to make a letter guess
---receive it
---check it against every letter in word
-----good: "correct letter guess"
-----bad: "incorrect. you have #{@@max_guesses} left"
4) Update displays if letter was correct or incorrect
5) Check if player is out of guesses
6) Check if player has won the game

NOUNS
1) A Display of how many guesses left before you lose (class variable)
2) A Display of correct letters and their position on the board (instance variable)
3) A Display of the incorrect letters already chosen (instance variable)
=end

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
    all_words = File.read('/Users/christianvillere/the_odin_project/Ruby/hangman/5desk.txt').split
    @word = all_words.select { |n| n.length >= 5 && n.length <= 12 }.sample(1)
    create_word_array.each { @correct_letters.push('_') }
    display_correct_letters
  end

  def create_word_array
    @word_array = @word.join('').split('')
  end

  def display_correct_letters
    p "You have #{@max_guesses} guesses remaining"
    puts "incorrect letters guessed: #{@incorrect_letters}"
    p @correct_letters.join(' ')
    puts "-------------------------------------------------"
    puts "What letter do you guess is a part of the word?"
    player_guess = gets.chomp.downcase
    deal_with_guess(player_guess)
  end

  def update_correct_guess(player_guess)
    @word_array.each_with_index do |n, index|
      if n == player_guess
        @correct_letters[index] = player_guess
      end
    end
    @max_guesses -= 1
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
        generate_random_word
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
      puts 'You have won the game! Would you like to play again? 1 for Yes & 2 for No'
      play_another_game
    end
    if @max_guesses.zero? == true && @correct_letters.include?('_') == true
      puts 'You have lost the game! Would you like to play again? 1 for Yes & 2 for No'
      play_another_game
    end
  end


  # work on creating a function for until condition to figure out what happens
  # at the end of a game both win and loss
  def deal_with_guess(player_guess)
    until @max_guesses.zero?
      if @word_array.include?(player_guess) == false
        pushing_incorrect_letters(player_guess)
      else
        update_correct_guess(player_guess)
      end
    end
  end

end

my_class = Hangman.new
my_class.generate_random_word
