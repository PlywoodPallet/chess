require_relative 'lib/chess_game'
require_relative 'lib/chess_board'
require_relative 'lib/chess_piece'
require_relative 'lib/move_validator'
require_relative 'lib/string' # console font styles

# Accomplishments
# Broke a lot of tests when designing remove_moves_jeopardize_king. Fixed by doing a major refactor of valid_moves. Split into valid_moves and estimate_moves
# LOTS of edge cases!


game = ChessGame.new
board = game.chess_board

exceptions_array = ['e8', 'e1', 'd1']
board.clear_board(exceptions_array)


board.print_board

p board.any_available_moves?

# testing any_available_moves? and statlemate
# need a ChessBoard clear_board(exceptions_array = nil) method. Clears all pieces except the ones in array
# place pieces into stalemate position
# test if statelemate? = true