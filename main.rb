require_relative 'lib/chess_game'
require_relative 'lib/chess_board'
require_relative 'lib/chess_piece'
require_relative 'lib/string' # console font styles


game = ChessGame.new

board = game.board

board.move_piece('e1', 'a4')

board.print_board

p board.get_valid_king_moves('a4')

# p board.get_piece('a4')