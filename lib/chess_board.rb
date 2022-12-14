require_relative '../lib/chess_piece'
require_relative '../lib/string' # console font styles

class ChessBoard
  attr_reader :board, :blank_value, :player1_king_coord, :player2_king_coord

  def initialize
    @blank_value = ' ' # needed for print_board to display correctly and so empty values aren't nil

    # String coordinate -> ChessPiece object
    @board = Hash.new # default value is nil so moves off the board can be detected

    @bg_colors = ['background_light_grey', 'background_dark_grey'] # row 8 first square, r8 second square
    @icon_colors = ['icon_orange', 'icon_black'] # player 1, player 2

    # When a player chooses a piece to move, bg color of that piece
    @highlighed_piece_bg_color = 'background_blue'
    # When a player chooses a piece to move, bg color of that piece
    @possible_moves_bg_color = 'background_green'

    # Track the coord of each players king for determining checkmate
    @player1_king_coord = nil
    @player2_king_coord = nil

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
    # Determine icon color
    icon_color = player_num == 1 ? @icon_colors[0] : @icon_colors[1]

    # Initialize pawns
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
    end

    # White: 8x Pawn - a2 to h2
    # Black: 8x Pawn - a7 to h7
    ('a'..'h').each do |letter|
      a_pawn = Pawn.new(player_num, icon_color)
      @board["#{letter}#{pawn_row}"] = a_pawn
    end

    # White: 2x Rook - a1, h1
    # Black: 2x Rook - a8, h8
    ['a', 'h'].each do |letter|
      a_rook = Rook.new(player_num, icon_color)
      @board["#{letter}#{back_row}"] = a_rook
    end

    # White: 2x Knight - b1, g1
    # Black: 2x Knight - b8, g8
    ['b', 'g'].each do |letter|
      a_knight = Knight.new(player_num, icon_color)
      @board["#{letter}#{back_row}"] = a_knight
    end

    # White: 2x Bishop - c1, f1
    # Black: 2x Bishop - c8, f8
    ['c', 'f'].each do |letter|
      a_bishop = Bishop.new(player_num, icon_color)
      @board["#{letter}#{back_row}"] = a_bishop
    end

    # White: 1x Queen - d1
    # Black: 1x Queen - d8
    queen = Queen.new(player_num, icon_color)
    @board["d#{back_row}"] = queen

    # White: 1x King - e1
    # Black: 1x King - e8
    king = King.new(player_num, icon_color)
    king_coord = "e#{back_row}"
    @board[king_coord] = king
    # initialize the variables that track the position of each players king
    player_num == 1 ? @player1_king_coord = king_coord : @player2_king_coord = king_coord
  end

  # print the board according to the format below (rows: descending numbers, col: ascending alphabet)
  # https://en.wikipedia.org/wiki/Chess
  # Board alignment - "queen starts on own color". White queen starts on white square, etc
  # valid_moves is for highlighting the valid moves of the selected piece at coordinate array (color2)
  # Print the chess board row by row (starting with row 8)
  def print_board (selected_piece_coord = nil, valid_moves = nil)
    print_col_label

    current_bg_color = @bg_colors[0] # first cell in upper left is white (a8)
    (1..8).reverse_each do |number| # start with row 8, end with row 1
      print_row_label(number)
      
      ('a'..'h').each do |letter|
        icon = @board["#{letter}#{number}"].to_s # explicit to_s needed for icon.send to work correctly

        # For some reason this creates black bars
        # icon = " #{icon} "

        coord = letter.to_s + number.to_s
        # highlight the coordinate selected by user
        if selected_piece_coord != nil && coord == selected_piece_coord
        # I have to print white space like this because the simpler solution above
        # creates black bars
          print "  ".send(@highlighed_piece_bg_color)
          print icon.send(@highlighed_piece_bg_color) # send bg color command directly to preserve checkered background
          print "  ".send(@highlighed_piece_bg_color)
        # highlight the possible moves of the piece
        elsif selected_piece_coord != nil && valid_moves.include?(coord)
          print "  ".send(@possible_moves_bg_color)
          print icon.send(@possible_moves_bg_color) # send bg color command directly to preserve checkered background
          print "  ".send(@possible_moves_bg_color)
        else
          print "  ".send(current_bg_color)
          print icon.send(current_bg_color)
          print "  ".send(current_bg_color)
        end

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
      print "  #{letter}  "
    end
    puts # new line
  end

  def print_row_label(number)
    print " #{number} "
  end

  # Move a piece on the board. No error checking
  # Captures are done by replacing one piece with another
  def move_piece(start_coord, end_coord)
    piece = get_piece(start_coord)
    @board[start_coord] = @blank_value
    @board[end_coord] = piece

    # Track the coordinates of each players king
    if piece.instance_of?(King)
      piece.player_num == 1 ? @player1_king_coord = end_coord : @player2_king_coord = end_coord
      # puts "Player #{piece.player_num} king has moved to #{end_coord}"
    end
  end
  
  # needed for piece restoration function in #remove_moves_that_jeopardize_king
  def set_piece_at_coord(coord, piece)
    @board[coord] = piece

    # Track the coordinates of each players king
    if piece.instance_of?(King)
      piece.player_num == 1 ? @player1_king_coord = coord : @player2_king_coord = coord
      # puts "Player #{piece.player_num} king has moved to #{end_coord}"
    end
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

  # Clears all pieces except the coords in array
  # exceptions_array = array of strings that store coords to keep
  # Needed for testing
  def clear_board(exceptions_array = nil)
    @board.each do |coord, piece|
      unless exceptions_array.include?(coord)
        @board[coord] = @blank_value
      end
    end
  end

  def get_king_coord_of_player(player_num)
    king_coord = nil

    case player_num
    when 1
      king_coord = player1_king_coord
    when 2
      king_coord = player2_king_coord
    end

    king_coord
  end

  def get_opponent_player_num(player_num)
    player_num == 1 ? 2 : 1
  end
end