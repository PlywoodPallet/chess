require_relative 'lib/chess_game'
require_relative 'lib/chess_board'
require_relative 'lib/chess_piece'
require_relative 'lib/string' # console font styles

board = ChessBoard.new
board.move_piece("b8", "c3")
board.print_board
p board.get_valid_knight_moves("c3")