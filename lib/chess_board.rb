# 8 x 8 grid
# x axis - lower case letters (a-h)
# y axis - numbers (1-8) starts at the bottom of the board then goes up

# rows are called ranks
# columns are called files

# Per Team - 16 pieces
# Pawn - 8
# Knight - 2
# Rook - 2
# Bishop - 2
# Queen - 1
# King - 1

# Board alignment - "queen starts on own color". White queen starts on white square, etc

# pieces are denoted by the file its in such as "pawn in f-file"

# 
# optional: alternating square color

class ChessBoard
  def initialize
    @blank_value = ' '

    # figure out a way for the index of row start at the bottom then go up
    # @board = Array.new(8) {Array.new(col, @blank_value)}


  end
end