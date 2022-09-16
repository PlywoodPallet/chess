# 8 x 8 grid
# x axis - lower case letters (a-h)
# y axis - numbers (1-8) starts at the bottom of the board then goes up

# rows are called ranks
# columns are called files

# pieces are denoted by the file its in such as "pawn in f-file"

# Colorize console text with ANSI escape codes
# https://en.wikipedia.org/wiki/ANSI_escape_code
# optional: alternating square color



# https://en.wikipedia.org/wiki/Chess if following this format, white is bottom two rows, black is top two rows

require_relative '../lib/chess_piece'
require_relative '../lib/string' # console font styles

class ChessBoard
  attr_reader :blank_value

  def initialize
    @blank_value = ' '

    # Benefits of using hash to represent the board: 
    # can store pieces in the exact coordinates that they are represented on the board (key a3 has the piece), rather than creating a 2d array where the location is no obvious

    # Cons 
    # Knights Travails written for a 2d array - can use a lookup 2d array that converts between coordinate key "a3" and y,x coordinates
    # Major/minor diagonal algo in Connect Four project written for 2d array
    @board = Hash.new # default value is nil so moves off the board can be detected

    @bg_colors = ['bg_white', 'bg_bright_black']

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
  # Board alignment - "queen starts on own color". White queen starts on white square, etc
  # TODO: center chess piece in square
  def print_board
    print_col_label

    current_bg_color = @bg_colors[0] # first cell in upper left is white (a8)
    (1..8).reverse_each do |number| # start with row 8, end with row 1
      print_row_label(number)
      
      ('a'..'h').each do |letter|
        icon = @board["#{letter}#{number}"].to_s # explicit to_s needed for icon.send to work correctly
        icon = "  #{icon}" # add spaces for display padding
        print icon.send(current_bg_color)

        # alternate between background colors
        current_bg_color = current_bg_color == @bg_colors[0] ? @bg_colors[1] : @bg_colors[0]
      end
      print_row_label(number)

      # first element in new row has different bg color
      current_bg_color = current_bg_color == @bg_colors[0] ? @bg_colors[1] : @bg_colors[0]
      puts # new line
    end

    print_col_label
  end

  def print_col_label
    print '   '
    ('a'..'h').each do |letter|
      print " #{letter} "
    end
    puts # new line
  end

  def print_row_label(number)
    print " #{number} "
  end

  # Move a piece on the board. No error checking
  def move_piece(start_coord, end_coord)
    piece = get_piece(start_coord)
    @board[start_coord] = @blank_value
    @board[end_coord] = piece
  end

  # Return the piece at a given coordinate
  # If no piece, return blank value. If off the board, return nil
  def get_piece(coord)
    @board[coord]
  end

  # return true if the coord contains a blank value, but not a nil value
  def coord_is_empty?(coord)
    return true if @board[coord] == @blank_value
    false
  end

  # return true if the coord contains a child of ChessPiece
  def coord_contains_piece?(coord)
    return true if @board[coord].class.superclass.name == 'ChessPiece'
    false
  end

  # this method should be in ChessBoard rather than ChessGame because valid moves need to take other pieces into consideration
  def get_valid_moves(piece, coord)

    # if piece can only move one square, do this code (Pawn, King)
    return get_valid_pawn_moves(piece, coord) if piece.class == "Pawn"
    # if piece can jump over other pieces, do this code (Knight)

    # if piece cannot jump over other pieces but can move in rows,col, or diag, do this code (Rook, Bishop, Queen)


  end

  # TODO: (1) Pawn standard attack move, (2) "en passant" special attack
  def get_valid_pawn_moves(piece, starting_coord)
    relative_moves = []
    player_num = piece.player

    # the pawn can only move forward, based on player (player1/white goes from bottom to top, player2/black goes from top to bottom)
    if player_num == 1
      relative_moves << [0, 1]
    elsif player_num == 2
      relative_moves << [0, -1]
    end

    # if pawn is in starting row, add another starting move where it can move two spaces
    # TODO: edge case where pawn has gone to the other player side and returned to the home row (without exchanging for another piece?) Highly unlikely
    starting_coord_y = starting_coord[1].to_i

    if player_num == 1 && starting_coord_y == 2
      relative_moves << [0, 2]
    elsif player_num == 2 && starting_coord_y == 7
      relative_moves << [0, -2]
    end

    relative_moves.map { |relative_move| convert_relative_to_absolute(starting_coord, relative_move) }
  end

  # given [1,2] and starting coordinate, return the absolute grid (ex. "d5")
  # TODO: what should this method do when the new absolute coord is out of bounds? Should this method have error checking?
  def convert_relative_to_absolute(starting_coord, relative_coord)
    relative_x = relative_coord[0].to_i
    relative_y = relative_coord[1].to_i

    letter_to_number_hash = {'a' => 1, 'b' => 2, 'c' => 3, 'd' => 4, 'e' => 5, 'f' => 6, 'g' => 7, 'h' => 8}
    starting_x = letter_to_number_hash[starting_coord[0]].to_i # first char is a letter, so it needs to be converted to a number
    starting_y = starting_coord[1].to_i

    number_to_letter_hash = letter_to_number_hash.invert
    absolute_x_letter = number_to_letter_hash[starting_x + relative_x] # convert from number back to letter
    absolute_y = starting_y + relative_y

    absolute_x_letter + absolute_y.to_s
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