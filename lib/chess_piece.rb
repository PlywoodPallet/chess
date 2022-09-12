# Accomplishments
# unicode white and black icons didn't look right. Opted to use a single icon but change the color to white or black

# Unneccessary
# location? - its stored in Board, pieces are chosen by grid coordinate
# legal moves? calculated by Game

require '../lib/string.rb' # console font styles

class ChessPiece
  attr_reader :player, :icon

  # player is nil by default
  def initialize(player = nil)
    @player = player
    @icon = nil
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