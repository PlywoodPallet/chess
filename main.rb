# Accomplishments
# Broke a lot of tests when designing remove_moves_jeopardize_king. Fixed by doing a major refactor of valid_moves. Split into valid_moves and estimate_moves
# LOTS of edge cases!
# Skipped en passant and castling. Much more Odin project left to do and didn't want to waste time implementing this. 
# Usability - user has ability to redo piece selection. When a piece is selected, the possible moves are highlighted on the board
# Making the command line interface look good was not a priority. This task is rarely done in the real world, except for debugging
# Found a code snippet online that adds to String class with commands to change console text and bg color, made print_board more readable than using ANSI console
# Early design decision of storing the board as a hash made debugging much easier!

# Further work
# Replit live version
# Make a nice Readme.md
#    Consider making post-project thoughts section or similar
#    https://github.com/JonathanYiv/chess
# Use design patterns to standarize methods and DRY: https://www.amazon.com/Design-Patterns-Ruby-Russ-Olsen/dp/0321490452
# Pawn - En passant attack
# Castle/King - Castling
# GameRecorder which stores each move (algebraic notation)
# Player 2 automated so that it picks a random move
# Import a ruby chess agent to be the automatic player 2
# Create a GameMessages module to take a lot of code out of ChessGame to make it more readable

require_relative 'lib/chess_game'
require_relative 'lib/chess_board'
require_relative 'lib/chess_piece'
require_relative 'lib/move_validator'
require_relative 'lib/string' # console font styles

p Dir.exist? 'saved_games'
p Dir.entries('saved_games/.')
p Dir.empty?('saved_games')
p Dir.empty?('empty_directory')


# game = ChessGame.new
# game.play_game

load_game.play