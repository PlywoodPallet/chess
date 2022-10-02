require_relative 'lib/chess_game'
require_relative 'lib/chess_board'
require_relative 'lib/chess_piece'
require_relative 'lib/string' # console font styles

board = ChessBoard.new
board.print_board
board.move_piece('e1', 'a3')
board.move_piece('e8', 'a6')

p board.player1_king_coord
p board.player2_king_coord

# param1 = 'a1'
# param2 = ['a2', 'b2']

# board.print_board(param1, param2)

# game = ChessGame.new
# game.play_game

