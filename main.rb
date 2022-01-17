# frozen_string_literal: true

# Project to build the Hangman game for Odin Project

=begin
###Pre-writing for Hangman
VERBS
1) Load in 5desk.txt file
2) Randomly select secret word between 5 and 12 characters long from file
3) Make guess of a letter (case insensitive)
4) Update displays if letter was correct or incorrect
5) Check if player is out of guesses

NOUNS
1) A Display of how many guesses left before you lose (class variable)
2) A Display of correct letters and their position on the board (instance variable)
3) A Display of the incorrect letters already chosen (instance variable)
=end

# Main class to play hangman game
class Hangman
  @@max_guesses = 9

  attr_accessor :correct_letters, :incorrect_letters

  def load_file
    File.read('/Users/christianvillere/the_odin_project/Ruby/hangman/5desk.txt').split
  end 
end

my_class = Hangman.new
p my_class.load_file
