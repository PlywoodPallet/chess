require_relative 'lib/chess_game'
require_relative 'lib/chess_board'
require_relative 'lib/chess_piece'
require_relative 'lib/string' # console font styles

board = ChessBoard.new
board.move_piece("e8", "e3")
board.print_board
p board.get_valid_king_moves("e3")

# queen = Queen.new(1)
# p queen.relative_moves