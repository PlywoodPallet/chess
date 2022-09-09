# Unneccessary
# location? - its stored in Board, pieces are chosen by grid coordinate
# legal moves? calculated by Game

# Player 1 = white
# Player 2 = black
# according to wikipedia

# Notes
# The "white" pieces look like black
# the "black" pieces look like white

class ChessPiece
  attr_reader :player, :icon

  # player is nil by default
  def initialize(player = nil)
    @player = player
    @icon = nil
  end

  # important for Chess_Board.print_board
  def to_s
    @icon
  end
end

class Pawn < ChessPiece
  def initialize(player = nil)
    super
    
    # white : black
    @icon = @player == 1 ? "\u2659" : "\u265F"
  end
end

class Knight < ChessPiece
  def initialize(player = nil)
    super
    
    # white : black
    @icon = @player == 1 ? "\u2658" : "\u265E"
  end
end

class Rook < ChessPiece
  def initialize(player = nil)
    super
    
    # white : black
    @icon = @player == 1 ? "\u2656" : "\u265C"
  end
end

class Bishop < ChessPiece
  def initialize(player = nil)
    super
    
    # white : black
    @icon = @player == 1 ? "\u2657" : "\u265D"
  end
end

class Queen < ChessPiece
  def initialize(player = nil)
    super
    
    # white : black
    @icon = @player == 1 ? "\u2655" : "\u265B"
  end
end

class King < ChessPiece
  def initialize(player = nil)
    super
    @hasCastled = false
    
    # white : black
    @icon = @player == 1 ? "\u2654" : "\u265A"
  end
end