require_relative 'lib/chess_game'
require_relative 'lib/chess_board'
require_relative 'lib/chess_piece'
require_relative 'lib/string' # console font styles

board = ChessBoard.new

board.move_piece("b1", "c6")
board.print_board
piece = board.get_piece("c6")
p board.get_valid_knight_moves(piece, "c6")