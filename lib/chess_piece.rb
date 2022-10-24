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
  end
end

class Rook < ChessPiece
  def initialize(player_num = nil, icon_color = nil)
    super(player_num, icon_color)
    
    @icon = "\u265C"
  end


end

class Bishop < ChessPiece
  def initialize(player_num = nil, icon_color = nil)
    super(player_num, icon_color)
    
    @icon = "\u265D"
  end
end

class Queen < ChessPiece
  def initialize(player_num = nil, icon_color = nil)
    super(player_num, icon_color)
    
    @icon = "\u265B"
  end
end

class King < ChessPiece
  def initialize(player_num = nil, icon_color = nil)
    super(player_num, icon_color)
    @hasCastled = false
    
    @icon = "\u265A"
  end
end