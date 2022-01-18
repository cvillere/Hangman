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
  end

  def create_word_array
    @word_array = @word.join('').split('')
  end

  def display_correct_letters
    create_word_array.each { @correct_letters.push('_') }
    p @correct_letters.join(' ')
  end

  def provide_output
    generate_random_word
    display_correct_letters
  end

  def update_incorrect_guess(player_guess)
    if @word_array.include?(player_guess) == false
      @incorrect_letters.push(player_guess)
    end
  end

  def grab_player_guess
    player_guess = gets.chomp.downcase
  end

  def update_correct_guess
    # check player_guess against @word_array and update correct_letters || incorrect_letters
    @word_array.each_with_index do |n, index|
      if n == player_guess 
        @correct_letters[index] = player_guess
        provide_output
      elsif @word_array.include?(player_guess)
        @incorrect_letters.push
      end
    end
  end

end

my_class = Hangman.new
my_class.provide_output
