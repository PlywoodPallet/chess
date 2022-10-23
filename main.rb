# Accomplishments
# Broke a lot of tests when designing remove_moves_jeopardize_king. Fixed by doing a major refactor of valid_moves. Split into valid_moves and estimate_moves
# LOTS of edge cases!
# Skipped en passant and castling. Much more Odin project left to do and didn't want to waste time implementing this. 
# Usability - user has ability to redo piece selection. When a piece is selected, the possible moves are highlighted on the board
# Making the command line interface look good was not a priority. This task is rarely done in the real world, except for debugging
# Found a code snippet online that adds to String class with commands to change console text and bg color, made print_board more readable than using ANSI console
# Early design decision of storing the board as a hash made debugging much easier!
# Royally messed up. Pushed code with bugs to remote (seemly minor change broke something - was minor so I pushed it). Learned how to use git reflog and git checkout to go back into time when code worked to start debugging
# I didn't use TDD, but writing unit tests was important for creating a project this size. As the complexity increased during development, A seemingly simple change in one part of code can create bugs in places that seemed unrelated or places I would have not thought to look if I had to debug without tests
# Moved all relevant methods from ChessBoard to MoveValidator
# Moved relative_moves from ChessPiece to MoveValidator

# Further work - Immediate
# Move relative_moves from ChessPiece to MoveValidator
# Make tests that play the game using rspec mocks and doubles
# Create a GameMessages module to take a lot of code out of ChessGame to make it more readable
# Other de-spaghettification
# Replit live version
# Make a nice Readme.md
#    Consider making post-project thoughts section or similar
#    https://github.com/JonathanYiv/chess

# Further work - Long Term
# Use design patterns to standarize methods and DRY: https://www.amazon.com/Design-Patterns-Ruby-Russ-Olsen/dp/0321490452
# Pawn - En passant attack
# Castle/King - Castling
# GameRecorder which stores each move (algebraic notation)
# Player 2 automated so that it picks a random move
# Import a ruby chess agent to be the automatic player 2

require_relative 'lib/chess_game'
require_relative 'lib/chess_board'
require_relative 'lib/chess_piece'
require_relative 'lib/move_validator'
require_relative 'lib/string' # console font styles

extend Serializable

def save_game_player_input
  verified_save_choice = ''
  loop do
    puts 'Saved game detected, would you like to restore it? (Yes/No)'
    verified_save_choice = verify_player_input(player_input)

    # break if not nil
    break if verified_save_choice
  end
  verified_save_choice
end

def verify_player_input(raw_input)
  return raw_input if raw_input.upcase == 'YES' || raw_input.upcase == 'NO'
  return 'yes' if raw_input.upcase == 'Y' # add these options for usability
  return 'no' if raw_input.upcase == 'N'
  nil
end

# get player input then convert to string
def player_input
  gets.chomp.to_s
end

# If a saved game is detected
if Dir.exist?('saved_games') && !Dir.empty?('saved_games')
  save_choice = save_game_player_input
  if save_choice.upcase == 'YES' || save_choice.upcase == 'Y'
    load_game.play_game
  else
    game = ChessGame.new
    game.play_game
  end
else
  game = ChessGame.new
  game.play_game
end

# game = ChessGame.new
# board = game.chess_board
# validator = game.move_validator
# board.clear_board('a1')
# p moves = validator.estimate_rook_bishop_queen_moves('a1')
# board.print_board
# game.play_game