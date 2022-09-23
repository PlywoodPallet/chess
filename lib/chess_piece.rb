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
# TODO: castling feature
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

    relative_moves << (1..8).collect { |num| [num, 0] }
    relative_moves << (1..8).collect { |num| [0, num] }
    relative_moves << (1..8).collect { |num| [-num, 0] }
    relative_moves << (1..8).collect { |num| [0, -num] }

    relative_moves
  end
end

  # relative_moves for Bishop class has a different array structure
  # [1, 2, 3, 4]
  #1 [[1, 1] to [8, 8]]
  #2 [[1, -1] to [8, -8]]
  #3 [[-1, -1] to [-8, -8]]
  #4 [[-1, 1] to [-8, 8]]
class Bishop < ChessPiece
  def initialize(player = nil)
    super
    
    @icon = "\u265D"
    @relative_moves = build_relative_moves
  end

  def build_relative_moves
    relative_moves = []

    relative_moves << (1..8).collect { |num| [num, num] }
    relative_moves << (1..8).collect { |num| [num, -num] }
    relative_moves << (1..8).collect { |num| [-num, -num] }
    relative_moves << (1..8).collect { |num| [-num, num] }

    relative_moves
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