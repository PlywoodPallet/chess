require_relative 'lib/chess_game'
require_relative 'lib/chess_board'
require_relative 'lib/chess_piece'
require_relative 'lib/string' # console font styles

# board = ChessBoard.new
# board.move_piece('b1', 'd4')
# board.print_board
# p board.get_valid_moves('d4')

game = ChessGame.new
game.play_game