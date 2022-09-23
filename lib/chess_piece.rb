# Accomplishments
# unicode white and black icons didn't look right. Opted to use a single icon but change the color to white or black

# Unneccessary
# location? - its stored in Board, pieces are chosen by grid coordinate
# legal moves? calculated by Game

# TODO: Change @player to @player_num, and refactor all other variable calls throughout the project

require_relative '../lib/string' # console font styles

class ChessPiece
  attr_reader :player, :icon, :relative_moves

  # player is nil by default
  # TODO: Refactor player to player_num for consistency with chessboard methods
  def initialize(player = nil)
    @player = player
    @icon_colors = ['bright_white', 'black'] # player 1, player 2
  end

  # important for Chess_Board.print_board
  # change icon color based on player
  def to_s
    # Player 1 = white (37)
    # Player 2 = black (30)
    @player == 1 ? @icon.to_s.send(@icon_colors[0]) : @icon.to_s.send(@icon_colors[1])
    
    # "\e[#{icon_color}m #{@icon}\e[0m"
  end

  # return the player number of the opponent
  def opponent_player_num
    @player == 1 ? 2 : 1
  end
end

# Note: relative moves are [x,y] or [col, row]

# removed @relative_moves because pawns can only move forward. The logic involved is in ChessBoard#get_valid_pawn_moves
class Pawn < ChessPiece
  def initialize(player = nil)
    super
    
    @icon = "\u265F"
  end
end

class Knight < ChessPiece
  def initialize(player = nil)
    super
    
    @icon = "\u265E"
    @relative_moves = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
  end
end

class Rook < ChessPiece
  def initialize(player = nil)
    super
    
    @icon = "\u265C"
    @relative_moves = build_relative_moves #NOTE: different array structure
  end

  # relative_moves for Rook classes have a different array structure
  # [1, 2, 3, 4]
  #1 [[1, 0] to [8, 0]] (move in row)
  #2 [[0, 1] to [0, 8]] (move in col)
  #3 [[-1, 0] to [-8, 0]]
  #4 [[0, -1] to [0, -8]]
  def build_relative_moves
    relative_moves = []

    relative_moves1 = []
    1.upto(8) do |num|
      relative_moves1 << [num, 0]
    end
    relative_moves << relative_moves1

    relative_moves2 = []
    1.upto(8) do |num|
      relative_moves2 << [0, num]
    end
    relative_moves << relative_moves2

    relative_moves3 = []
    -1.downto(-8) do |num|
      relative_moves3 << [num, 0]
    end
    relative_moves << relative_moves3

    relative_moves4 = []
    -1.downto(-8) do |num|
      relative_moves4 << [0, num]
    end
    relative_moves << relative_moves4

    relative_moves
  end
end

#TODO: castling feature
class Bishop < ChessPiece
  def initialize(player = nil)
    super
    
    @icon = "\u265D"
  end
end

class Queen < ChessPiece
  def initialize(player = nil)
    super
    
    @icon = "\u265B"
  end
end

class King < ChessPiece
  def initialize(player = nil)
    super
    @hasCastled = false
    
    @icon = "\u265A"
  end
end