# Accomplishments
# unicode white and black icons didn't look right. Opted to use a single icon but change the color to white or black

# Unneccessary
# location? - its stored in Board, pieces are chosen by grid coordinate
# legal moves? calculated by Game

class ChessPiece
  attr_reader :player, :icon

  # player is nil by default
  def initialize(player = nil)
    @player = player
    @icon = nil
  end

  # important for Chess_Board.print_board
  # change icon color based on player
  def to_s
    # Player 1 = white (37)
    # Player 2 = black (30)
    icon_color = @player == 1 ? 37 : 30
    
    "\e[#{icon_color}m #{@icon}\e[0m"
  end
end

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
  end
end

class Rook < ChessPiece
  def initialize(player = nil)
    super
    
    @icon = "\u265C"
  end
end

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