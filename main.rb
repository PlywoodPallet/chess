require_relative 'lib/chess_game'
require_relative 'lib/chess_board'
require_relative 'lib/chess_piece'
require_relative 'lib/string' # console font styles


game = ChessGame.new
board = game.board
board.move_piece('e1', 'd4') # move king into position
board.move_piece('d2', 'd3') # block king with own pawn
board.move_piece('a8', 'c4') # move opponent rook to threaten king
board.move_piece('b8', 'b5') # move opponent knight to threaten king

game.play_game


# DID I CREATE A TEST FOR THIS? I think the problem here is that get_threatening_pieces assumes the player_num/opponent_player_num. player_num needs to be a parameter so I can find the threatening pieces for a consistent player 