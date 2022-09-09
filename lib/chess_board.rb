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


# optional: alternating square color
# https://en.wikipedia.org/wiki/Chess if following this format, white is bottom two rows, black is top two rows

class ChessBoard
  def initialize
    @blank_value = '*'

    # Benefits of using hash to represent the board: 
    # can store pieces in the exact coordinates that they are represented on the board (key a3 has the piece), rather than creating a 2d array where the location is no obvious

    # Cons 
    # Knights Travails written for a 2d array - can use a lookup 2d array that converts between coordinate key "a3" and y,x coordinates
    # Major/minor diagonal algo in Connect Four project written for 2d array
    @board = Hash.new # default value is nil so moves off the board can be detected
    initialize_board
  end

  # initialize the board according to the format below (rows: descending numbers, col: ascending alphabet)
  # https://en.wikipedia.org/wiki/Chess
  def initialize_board
    (1..8).reverse_each do |number|
      ('a'..'h').each do |letter|
        @board["#{letter}#{number}"] = @blank_value
      end
    end
  end

  # print the board according to the format below (rows: descending numbers, col: ascending alphabet)
  # https://en.wikipedia.org/wiki/Chess
  def print_board
    (1..8).reverse_each do |number|
      ('a'..'h').each do |letter|
        print @board["#{letter}#{number}"]
        print " " # space in between items
      end
      puts # new line
    end
  end

  # sanity check: print the keys-value pairs in @board
  # for debugging only
  def sanity_check
      (1..8).reverse_each do |number|
        ('a'..'h').each do |letter|
          print "#{letter}#{number}:" 
          print @board["#{letter}#{number}"]
          
          print " " # space in between items
        end
        puts # new line
      end
  end

end

board = ChessBoard.new
board.print_board