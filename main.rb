require_relative 'lib/chess_game'
require_relative 'lib/chess_board'
require_relative 'lib/chess_piece'
require_relative 'lib/string' # console font styles

board = ChessBoard.new
board.move_piece("d8", "d4")
board.print_board
p board.get_valid_queen_moves("d4")

# queen = Queen.new(1)
# p queen.relative_moves