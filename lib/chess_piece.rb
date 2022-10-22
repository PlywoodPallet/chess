# Accomplishments
# unicode white and black icons didn't look right. Opted to use a single icon but change the color to white or black

# Unneccessary
# location? - its stored in Board, pieces are chosen by grid coordinate
# legal moves? calculated by Game

# TODO: Change @player to @player_num, and refactor all other variable calls throughout the project

require_relative '../lib/string' # console font styles

class ChessPiece
  attr_reader :player_num, :icon, :relative_moves

  # player is nil by default
  def initialize(player_num = nil, icon_color = nil)
    @player_num = player_num
    @icon_color = icon_color
  end

  # important for Chess_Board.print_board
  # change icon color based on player
  def to_s
    @icon.to_s.send(@icon_color)
  end

  # return the player number of the opponent
  def opponent_player_num
    @player_num == 1 ? 2 : 1
  end
end

# Note: relative moves are [x,y] or [col, row]

# removed @relative_moves because pawns can only move forward. The logic involved is in ChessBoard#get_valid_pawn_moves
# TODO: castling feature
class Pawn < ChessPiece
  def initialize(player_num = nil, icon_color = nil)
    super(player_num, icon_color)
    
    @icon = "\u265F"
  end
end

class Knight < ChessPiece
  def initialize(player_num = nil, icon_color = nil)
    super(player_num, icon_color)
    
    @icon = "\u265E"
    @relative_moves = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
  end
end

class Rook < ChessPiece
  def initialize(player_num = nil, icon_color = nil)
    super(player_num, icon_color)
    
    @icon = "\u265C"
    @relative_moves = build_relative_moves #NOTE: different array structure
  end

  # relative_moves for Rook classes have a different array structure
  # [1, 2, 3, 4]
  # 1 [[1, 0] to [8, 0]] (move in row)
  # 2 [[0, 1] to [0, 8]] (move in col)
  # 3 [[-1, 0] to [-8, 0]]
  # 4 [[0, -1] to [0, -8]]
  # output = [[subarray1], [subarray2], [subarray3], [subarray4]]
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
  # 1 [[1, 1] to [8, 8]]
  # 2 [[1, -1] to [8, -8]]
  # 3 [[-1, -1] to [-8, -8]]
  # 4 [[-1, 1] to [-8, 8]]
  # output = [[subarray1], [subarray2], [subarray3], [subarray4]]
class Bishop < ChessPiece
  def initialize(player_num = nil, icon_color = nil)
    super(player_num, icon_color)
    
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
  def initialize(player_num = nil, icon_color = nil)
    super(player_num, icon_color)
    
    @icon = "\u265B"
    @relative_moves = build_relative_moves
  end

  # TODO: Change Rook.build_relative_moves and Bishop_build_relative_moves into static methods that can be directly called here
  # Queen has the combined moves of Rook and Bishop
  def build_relative_moves
    # player number doesn't matter
    rook = Rook.new(1) 
    bishop = Bishop.new(1)

    rook.relative_moves + bishop.relative_moves
  end
end

class King < ChessPiece
  def initialize(player_num = nil, icon_color = nil)
    super(player_num, icon_color)
    @hasCastled = false
    
    @icon = "\u265A"
    @relative_moves = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
  end
end