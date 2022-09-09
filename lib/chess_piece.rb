# player = 1 or 2
# unicode icon (white or black)

# Unneccessary
# location? - its stored in Board, pieces are chosen by grid coordinate
# legal moves? calculated by Game

# Pawn
# Knight
# Rook
# Bishop
# Queen
# King

class ChessPiece
  def initialize (player = nil)
    @player = player
  end
end

class Pawn < ChessPiece
end

class Knight < ChessPiece
end

class Rook < ChessPiece
end

class Bishop < ChessPiece
end

class Queen < ChessPiece
end

class King < ChessPiece
end