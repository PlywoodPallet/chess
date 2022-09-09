# 8 x 8 grid
# x axis - lower case letters (a-h)
# y axis - numbers (1-8) starts at the bottom of the board then goes up

# rows are called ranks
# columns are called files



# Board alignment - "queen starts on own color". White queen starts on white square, etc

# pieces are denoted by the file its in such as "pawn in f-file"

# Colorize console text with ANSI escape codes
# https://en.wikipedia.org/wiki/ANSI_escape_code
# optional: alternating square color



# https://en.wikipedia.org/wiki/Chess if following this format, white is bottom two rows, black is top two rows

require '../lib/chess_piece'

class ChessBoard
  def initialize
    @blank_value = ' '

    # Benefits of using hash to represent the board: 
    # can store pieces in the exact coordinates that they are represented on the board (key a3 has the piece), rather than creating a 2d array where the location is no obvious

    # Cons 
    # Knights Travails written for a 2d array - can use a lookup 2d array that converts between coordinate key "a3" and y,x coordinates
    # Major/minor diagonal algo in Connect Four project written for 2d array
    @board = Hash.new # default value is nil so moves off the board can be detected
    initialize_board_coordinates
    initialize_player_pieces(1)
    initialize_player_pieces(2)
  end

  # initialize the board coordinates with blank value
  def initialize_board_coordinates
    (1..8).reverse_each do |number|
      ('a'..'h').each do |letter|
        @board["#{letter}#{number}"] = @blank_value
      end
    end
  end

  # initialization is hard coded beacuse the board is the same at the start of every chess game
  # TODO: Can I practice using a lamda or proc here?
  # White = player 1, Black = player 2
  def initialize_player_pieces(player_num)
    back_row = nil
    pawn_row = nil

    case player_num
    when 1
      back_row = 1
      pawn_row = 2
    when 2
      back_row = 8
      pawn_row = 7
    else
      puts 'Invalid player number'
      # Learn how to throw errors
    end

    # White: 8x Pawn - a2 to h2
    # Black: 8x Pawn - a7 to h7
    ('a'..'h').each do |letter|
      a_pawn = Pawn.new(player_num)
      @board["#{letter}#{pawn_row}"] = a_pawn
    end

    # White: 2x Rook - a1, h1
    # Black: 2x Rook - a8, h8
    ['a', 'h'].each do |letter|
      a_rook = Rook.new(player_num)
      @board["#{letter}#{back_row}"] = a_rook
    end

    # White: 2x Knight - b1, g1
    # Black: 2x Knight - b8, g8
    ['b', 'g'].each do |letter|
      a_knight = Knight.new(player_num)
      @board["#{letter}#{back_row}"] = a_knight
    end

    # White: 2x Bishop - c1, f1
    # Black: 2x Bishop - c8, f8
    ['c', 'f'].each do |letter|
      a_bishop = Bishop.new(player_num)
      @board["#{letter}#{back_row}"] = a_bishop
    end

    # White: 1x Queen - d1
    # Black: 1x Queen - d8
    queen = Queen.new(player_num)
    @board["d#{back_row}"] = queen

    # White: 1x King - e1
    # Black: 1x King - e8
    king = King.new(player_num)
    @board["e#{back_row}"] = king
  end

  # print the board according to the format below (rows: descending numbers, col: ascending alphabet)
  # https://en.wikipedia.org/wiki/Chess
  def print_board
    (1..8).reverse_each do |number|
      ('a'..'h').each do |letter|
        print @board["#{letter}#{number}"]
        print '  ' # space in between items
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
          
          print '  ' # space in between items
        end
        puts # new line
      end
  end

end

board = ChessBoard.new
board.print_board