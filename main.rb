require_relative 'lib/chess_game'
require_relative 'lib/chess_board'
require_relative 'lib/chess_piece'
require_relative 'lib/string' # console font styles

board = ChessBoard.new

param1 = 'a1'
param2 = ['a2', 'b2']

board.print_board(param1, param2)