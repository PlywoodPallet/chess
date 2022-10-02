# 8 x 8 grid
# x axis - lower case letters (a-h)
# y axis - numbers (1-8) starts at the bottom of the board then goes up
# "Queen on own color"

# should finding valid moves be in a separate class? "move_validator"
# TODO: VScode console and Linux terminal display the board differently. Alternates each player color from black and white

# https://en.wikipedia.org/wiki/Chess if following this format, white is bottom two rows, black is top two rows

# Design decision: Decided to hardcode relative moves for all pieces. I do not expect the rules of Chess to change so I wanted to skip needing to develop a clever algo to determine knight, rook, bishop, queen. #get_valid_x_move methods just iterate through the relative moves array
# Design decision: Use a hash to store the board: can store pieces in the exact coordinates that they are represented on the board (key a3 has the piece), rather than creating a 2d array where the location is no obvious

require_relative '../lib/chess_piece'
require_relative '../lib/string' # console font styles

class ChessBoard
  attr_reader :blank_value

  def initialize
    @blank_value = ' ' # needed for print_board to display correctly and so empty values aren't nil

    # Benefits of using hash to represent the board: 
    # can store pieces in the exact coordinates that they are represented on the board (key a3 has the piece), rather than creating a 2d array where the location is no obvious

    # Cons 
    # Knights Travails written for a 2d array - can use a lookup 2d array that converts between coordinate key "a3" and y,x coordinates
    # Major/minor diagonal algo in Connect Four project written for 2d array
    @board = Hash.new # default value is nil so moves off the board can be detected

    @bg_colors = ['bg_white', 'bg_bright_black']

    # When a player chooses a piece to move, bg color of that piece
    @highlighed_piece_bg_color = 'bg_cyan'
    # When a player chooses a piece to move, bg color of that piece
    @possible_moves_bg_color = 'bg_green'

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
  # TODO: add two parameters and background-highlighting function
  # selected_piece is for highlighting the piece selected by user at coordinate (color1)
  # valid_moves is for highlighting the valid moves of the selected piece at coordinate array (color2)
  def print_board (selected_piece_coord = nil, valid_moves = nil)
    print_col_label

    current_bg_color = @bg_colors[0] # first cell in upper left is white (a8)
    (1..8).reverse_each do |number| # start with row 8, end with row 1
      print_row_label(number)
      
      ('a'..'h').each do |letter|
        icon = @board["#{letter}#{number}"].to_s # explicit to_s needed for icon.send to work correctly
        icon = "  #{icon}" # add spaces for display padding

        coord = letter.to_s + number.to_s

        # highlight the coordinate selected by user
        if selected_piece_coord != nil && coord == selected_piece_coord
          print icon.send(@highlighed_piece_bg_color) # send bg color command directly to preserve checkered background
        # highlight the possible moves of the piece
        elsif selected_piece_coord != nil && valid_moves.include?(coord)
          print icon.send(@possible_moves_bg_color) # send bg color command directly to preserve checkered background
        else
          print icon.send(current_bg_color)
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
  def get_valid_moves(starting_coord)

    piece = get_piece(starting_coord)

    # if piece is a pawn do this code (Pawn)
    return get_valid_pawn_moves(starting_coord) if piece.instance_of?(Pawn)
    # if piece can jump over other pieces, do this code (Knight)
    return get_valid_knight_moves(starting_coord) if piece.instance_of?(Knight)
    # if piece cannot jump over other pieces but can move in rows,col (Rook)
    return get_valid_rook_moves(starting_coord) if piece.instance_of?(Rook)
    # if piece cannot jump over other pieces but can move in diagonals (Bishop)
    return get_valid_bishop_moves(starting_coord) if piece.instance_of?(Bishop)
    # if piece cannot jump over other pieces but can move in rows,col and diagonals (Queen)
    return get_valid_queen_moves(starting_coord) if piece.instance_of?(Queen)
    # if piece is a king, do this code (King)
    return get_valid_king_moves(starting_coord) if piece.instance_of?(King)
    
    puts 'Error: Chess piece not recognized'
  end

  # TODO: (1) "en passant" special attack, (2) pawn promotion, (3) refactor into elegant code
  # Pawns are the only piece can only move in a certain direction, which requires extra complexity
  # "en passant" is a reaction to an opponent pawn's 2 square initial move. Is only available immediately afterwards
  def get_valid_pawn_moves(starting_coord)
    relative_moves = []
    absolute_moves = []
    piece = get_piece(starting_coord)
    player_num = piece.player_num

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

    # these are non-attack moves
    absolute_moves = relative_moves.map { |relative_move| convert_relative_to_absolute(starting_coord, relative_move) }
    
    # First value in array is a 1 square move, second value in the array is a 2 square move
    # if [0,1]/[0,-1] are invalid, piece is blocked so remove all moves
    if coord_contains_piece?(absolute_moves[0])
      absolute_moves.clear

    # if [0,2]/[0,-2] are invalid but [0,1]/[0,-1] is valid, only remove the former
    elsif coord_contains_piece?(absolute_moves[1])
      absolute_moves.pop
    end

    # scan for enemy pieces for standard attack
    # TODO: clean up code, lots of repetition here
    if player_num == 1
      relative_attack_moves = []
      relative_attack_moves << [-1, 1]
      relative_attack_moves << [1, 1]
      absolute_attack_moves = relative_attack_moves.map { |relative_move| convert_relative_to_absolute(starting_coord, relative_move) }

      # select attack move coordinates that contain a piece belonging to the opponent
      valid_absolute_attack_moves = absolute_attack_moves.select { |absolute_move| coord_contains_piece?(absolute_move) && get_piece(absolute_move).player_num == 2 }
      absolute_moves += valid_absolute_attack_moves
    elsif player_num == 2
      relative_attack_moves = []
      relative_attack_moves << [-1, -1]
      relative_attack_moves << [1, -1]
      absolute_attack_moves = relative_attack_moves.map { |relative_move| convert_relative_to_absolute(starting_coord, relative_move) }

      # select attack move coordinates that contain a piece belonging to the opponent
      valid_absolute_attack_moves = absolute_attack_moves.select { |absolute_move| coord_contains_piece?(absolute_move) && get_piece(absolute_move).player_num == 1}
      absolute_moves += valid_absolute_attack_moves
    end

    # scan for "en passant" special attack

    absolute_moves
  end

  # TODO: remove the piece parameter and just access it with get_piece()
  # TODO: refactor method remove if elsif. Use method that gets the opponents player number
  def get_valid_knight_moves(starting_coord)
    piece = get_piece(starting_coord)
    player_num = piece.player_num
    # get the relative moves from the piece
    relative_moves = piece.relative_moves

    # convert relatives moves to absolute moves based on starting coord
    absolute_moves = relative_moves.map { |relative_move| convert_relative_to_absolute(starting_coord, relative_move) }

    # select all moves that go to an empty space OR an opponent's piece
    valid_absolute_moves = []
    valid_absolute_attack_moves = []
    if player_num == 1
      valid_absolute_moves = absolute_moves.select { |absolute_move| coord_is_empty?(absolute_move)}

      valid_absolute_attack_moves = absolute_moves.select { |absolute_move| coord_contains_piece?(absolute_move) && get_piece(absolute_move).player_num == 2}
    elsif player_num == 2
      valid_absolute_moves = absolute_moves.select { |absolute_move| coord_is_empty?(absolute_move)}

      valid_absolute_attack_moves = absolute_moves.select { |absolute_move| coord_contains_piece?(absolute_move) && get_piece(absolute_move).player_num == 1}
    end

    valid_absolute_moves + valid_absolute_attack_moves
  end

  # Rook can move multiple squares cannot jump over other pieces
  # Rook.relative_moves has a different data structure. Each subarray contains dimension (up,down,left,right). Each subarray goes from 1-square move to 8-square move. The method checks 1 move first, then 2nd move, etc. If one move contains a piece, the iteration stops and all other moves are not considered. This prevents rooks from jumping over pieces
  
  def get_valid_rook_moves(starting_coord)
    piece = get_piece(starting_coord)
    player_num = piece.player_num
    opponent_player_num = piece.opponent_player_num
    # get the relative moves from the piece
    relative_moves = piece.relative_moves

    # note: moves off the board are converted to nil
    absolute_moves = relative_moves.map do |subarray|
      subarray.map { |relative_move| convert_relative_to_absolute(starting_coord, relative_move) }
    end

    valid_absolute_moves = []

    # for each sub array, iterate from start to finish. 
    # Check if current coord is empty, if it is, add to a list to valid absolute moves
    # If the coord is off the board (nil result) 
    # If the coord is not empty. 
    # (1) If it contains an opponent piece, add to valid moves and break out of subarray iteration 
    # (2) If it contains an friendly piece, break out of subarray iteration 
    absolute_moves.each do |subarray|
      subarray.each do |absolute_move|
        break if absolute_move.nil? # stop subarray iteration if the move is off the board
        break if coord_contains_piece?(absolute_move) && get_piece(absolute_move).player_num == player_num

        # (1) If it contains an opponent piece, add to valid moves and break out of subarray iteration 
        if coord_contains_piece?(absolute_move) && get_piece(absolute_move).player_num == opponent_player_num
          valid_absolute_moves << absolute_move
          break
        end
        
        valid_absolute_moves << absolute_move
      end
    end

    valid_absolute_moves
  end

  # Consider making a general method for bishop, rook and queen
  def get_valid_bishop_moves(starting_coord)
    get_valid_rook_moves(starting_coord)
  end

  def get_valid_queen_moves(starting_coord)
    get_valid_rook_moves(starting_coord)
  end

  # Consider making a general method for knight and king
  def get_valid_king_moves(starting_coord)
    get_valid_knight_moves(starting_coord)
  end

  # given a starting coordinate and relative move (ex [0,1]), return the absolute grid (ex. "d5")
  # if absolute x or y coord is out of bounds, return nil
  def convert_relative_to_absolute(starting_coord, relative_coord)
    relative_x = relative_coord[0].to_i
    relative_y = relative_coord[1].to_i

    letter_to_number_hash = {'a' => 1, 'b' => 2, 'c' => 3, 'd' => 4, 'e' => 5, 'f' => 6, 'g' => 7, 'h' => 8}
    starting_x = letter_to_number_hash[starting_coord[0]].to_i # first char is a letter, so it needs to be converted to a number
    starting_y = starting_coord[1].to_i

    number_to_letter_hash = letter_to_number_hash.invert
    absolute_x_letter = number_to_letter_hash[starting_x + relative_x] # convert from number back to letter
    absolute_y = starting_y + relative_y

    # if absolute x or y coord is out of bounds, return nil
    return nil if absolute_x_letter.nil?
    return nil if absolute_y < 1 || absolute_y > 8

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