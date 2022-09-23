require_relative 'lib/chess_game'
require_relative 'lib/chess_board'
require_relative 'lib/chess_piece'
require_relative 'lib/string' # console font styles

board = ChessBoard.new
board.move_piece("a1", "d4")
board.move_piece("a7", "f4")
board.print_board
p board.get_valid_rook_moves("d4")

# rook = Rook.new(1)
# p rook.opponent_player_num