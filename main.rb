require_relative 'lib/chess_game'
require_relative 'lib/chess_board'
require_relative 'lib/chess_piece'
require_relative 'lib/string' # console font styles


game = ChessGame.new
board = game.chess_board

board.move_piece('e2', 'f3') # move pawn out of the way
board.move_piece('e7', 'f6') # move pawn out of the way


board.print_board