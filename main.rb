require '../lib/chess_game'
require '../lib/chess_board'
require '../lib/chess_piece'
require '../lib/string' # console font styles

# board = ChessBoard.new
# board.print_board
# board.move_piece('a2', 'a3')
# board.print_board

game = ChessGame.new
p game.enter_start_coord(1)