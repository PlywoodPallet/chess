require_relative 'lib/chess_game'
require_relative 'lib/chess_board'
require_relative 'lib/chess_piece'
require_relative 'lib/string' # console font styles

board = ChessBoard.new
board.print_board
# p board.coord_is_empty?('a2')
# p board.coord_is_empty?('a3')
# board.move_piece('a2', 'a3')
# board.print_board

p board.convert_relative_to_absolute('a2', [0,1])

# game = ChessGame.new
# game.print_board
# game.select_piece(1)