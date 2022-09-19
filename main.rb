require_relative 'lib/chess_game'
require_relative 'lib/chess_board'
require_relative 'lib/chess_piece'
require_relative 'lib/string' # console font styles

board = ChessBoard.new

# p board.coord_is_empty?('a2')
# p board.coord_is_empty?('a3')
# board.move_piece('a2', 'a3')
# board.print_board

# p board.convert_relative_to_absolute('a2', [0,1])

board.move_piece('c7', 'c4')
board.move_piece('b7', 'b3')
board.print_board

piece = board.get_piece("c2")
p board.get_valid_pawn_moves(piece, "a2")

# game = ChessGame.new
# game.print_board
# game.select_piece(1)