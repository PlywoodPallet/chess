require_relative '../lib/chess_piece'

# For determining if a move is valid given the state of the board
# Each ChessPiece object contains @relative_moves array which specifies
class MoveValidator
  def initialize (chess_board)
    @chess_board = chess_board


  end

  # legal moves
  # remove any moves that would jeopardize own king
  def valid_moves(starting_coord, pawn_attack_only = false)
    moves_array = estimate_moves(starting_coord, pawn_attack_only)
    remove_moves_that_jeopardize_king(starting_coord, moves_array)
  end

  # estimate moves
  # these methods will return moves that will jeopardize own king
  # these methods are needed to prevent infinite loops involving #remove_moves_that_jeopardize_king
  def estimate_moves(starting_coord, pawn_attack_only = false)
    piece = @chess_board.get_piece(starting_coord)

    # if piece is a pawn do this code (Pawn)
    return estimate_pawn_moves(starting_coord, pawn_attack_only) if piece.instance_of?(Pawn)
    # if piece can jump over other pieces, do this code (Knight)
    return estimate_knight_moves(starting_coord) if piece.instance_of?(Knight)
    # if piece cannot jump over other pieces but can move in rows,col (Rook)
    return estimate_rook_moves(starting_coord) if piece.instance_of?(Rook)
    # if piece cannot jump over other pieces but can move in diagonals (Bishop)
    return estimate_bishop_moves(starting_coord) if piece.instance_of?(Bishop)
    # if piece cannot jump over other pieces but can move in rows,col and diagonals (Queen)
    return estimate_queen_moves(starting_coord) if piece.instance_of?(Queen)
    # if piece is a king, do this code (King)
    return estimate_king_moves(starting_coord) if piece.instance_of?(King)

    puts "Error: No chess piece at #{starting_coord}" if piece == @chess_board.blank_value
    
    puts 'Error: Chess piece not recognized'
  end

  # TODO: (1) "en passant" special attack, (2) pawn promotion, (3) refactor into elegant code
  # Pawns are the only piece can only move in a certain direction, which requires extra complexity
  # "en passant" is a reaction to an opponent pawn's 2 square initial move. Is only available immediately afterwards
  # pawn_attack_only feature only returns attack moves. This is used to
  # determine if a pawn is threatening a king, check and checkmate
  def estimate_pawn_moves(starting_coord, pawn_attack_only = false)
    relative_moves = []
    absolute_moves = []
    piece = @chess_board.get_piece(starting_coord)
    player_num = piece.player_num
    opponent_player_num = piece.opponent_player_num

    if pawn_attack_only == false
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
      if @chess_board.coord_contains_piece?(absolute_moves[0])
        absolute_moves.clear
      # if [0,2]/[0,-2] are invalid but [0,1]/[0,-1] is valid, only remove the former
      elsif @chess_board.coord_contains_piece?(absolute_moves[1])
        absolute_moves.pop
      end
    end
    
    # scan for enemy pieces for standard attack
    relative_attack_moves = []
    if player_num == 1
      relative_attack_moves << [-1, 1]
      relative_attack_moves << [1, 1]
    elsif player_num == 2
      relative_attack_moves << [-1, -1]
      relative_attack_moves << [1, -1]
    end

    absolute_attack_moves = relative_attack_moves.map { |relative_move| convert_relative_to_absolute(starting_coord, relative_move) }
    # select attack move coordinates that contain a piece belonging to the opponent
    valid_absolute_attack_moves = absolute_attack_moves.select { |absolute_move| @chess_board.coord_contains_piece?(absolute_move) && @chess_board.get_piece(absolute_move).player_num == opponent_player_num}
    absolute_moves += valid_absolute_attack_moves

    # scan for "en passant" special attack

    absolute_moves
  end

  def estimate_knight_moves(starting_coord)
    piece = @chess_board.get_piece(starting_coord)
    # player_num = piece.player_num
    opponent_player_num = piece.opponent_player_num
    # get the relative moves from the piece
    relative_moves = piece.relative_moves

    # convert relatives moves to absolute moves based on starting coord
    absolute_moves = relative_moves.map { |relative_move| convert_relative_to_absolute(starting_coord, relative_move) }

    # select all moves that go to an empty space OR an opponent's piece
    valid_absolute_moves = absolute_moves.select { |absolute_move| @chess_board.coord_is_empty?(absolute_move)}
    valid_absolute_attack_moves = absolute_moves.select { |absolute_move| @chess_board.coord_contains_piece?(absolute_move) && @chess_board.get_piece(absolute_move).player_num == opponent_player_num}

    valid_absolute_moves + valid_absolute_attack_moves
  end

  # Rook can move multiple squares cannot jump over other pieces
  # Rook.relative_moves has a different data structure. Each subarray contains dimension (up,down,left,right). Each subarray goes from 1-square move to 8-square move. The method checks 1 move first, then 2nd move, etc. If one move contains a piece, the iteration stops and all other moves are not considered. This prevents rooks from jumping over pieces
  
  def estimate_rook_moves(starting_coord)
    piece = @chess_board.get_piece(starting_coord)
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
        break if @chess_board.coord_contains_piece?(absolute_move) && @chess_board.get_piece(absolute_move).player_num == player_num # stop iteration if come across own player's piece

        # (1) If it contains an opponent piece, add to valid moves and break out of subarray iteration 
        if @chess_board.coord_contains_piece?(absolute_move) && @chess_board.get_piece(absolute_move).player_num == opponent_player_num
          valid_absolute_moves << absolute_move
          break
        end
        
        valid_absolute_moves << absolute_move
      end
    end

    valid_absolute_moves
  end

  # Consider making a general method for bishop, rook and queen
  def estimate_bishop_moves(starting_coord)
    estimate_rook_moves(starting_coord)
  end

  def estimate_queen_moves(starting_coord)
    estimate_rook_moves(starting_coord)
  end

  # NOTE: Implementing this method for debugging purposes only
  # NOTE: This method should call #get_valid_knight_moves
  # Consider making a general method for knight and king
  def estimate_king_moves(starting_coord)
    # get_valid_knight_moves(starting_coord)
    piece = @chess_board.get_piece(starting_coord)
    # player_num = piece.player_num
    opponent_player_num = piece.opponent_player_num
    # get the relative moves from the piece
    relative_moves = piece.relative_moves

    # convert relatives moves to absolute moves based on starting coord
    absolute_moves = relative_moves.map { |relative_move| convert_relative_to_absolute(starting_coord, relative_move) }

    # select all moves that go to an empty space OR an opponent's piece
    valid_absolute_moves = absolute_moves.select { |absolute_move| @chess_board.coord_is_empty?(absolute_move)}
    valid_absolute_attack_moves = absolute_moves.select { |absolute_move| @chess_board.coord_contains_piece?(absolute_move) && @chess_board.get_piece(absolute_move).player_num == opponent_player_num}

    output = valid_absolute_moves + valid_absolute_attack_moves
  end

  # given a starting_coord of the piece that wants to move
  # given the absolute_moves_array of mostly valid moves 
  # determined by get_valid_x_moves methods
  # only return moves that DO NOT threaten own king
  # NOTE: this method works if the starting_coord is the king, will determine which moves are valid
  def remove_moves_that_jeopardize_king(starting_coord, moves_array)
    piece = @chess_board.get_piece(starting_coord)
    player_num = piece.player_num
    
    legal_moves_array = []
    moves_array.each do |coord|

      # if a piece exists at the move location, save it
      piece_at_coord = nil
      piece_at_coord = @chess_board.get_piece(coord) if @chess_board.coord_contains_piece?(coord)

      # For every possible move, temporarily move the piece to the coord
      # then, run get_threatening_pieces
      @chess_board.move_piece(starting_coord, coord)
      king_coord = @chess_board.get_king_coord_of_player(player_num) # moved from original location to allow method to run if starting_coord = king position
      opponent_pieces_targeting_king = get_threatening_pieces(king_coord, player_num)

      opponent_attack_moves = opponent_pieces_targeting_king.map { |piece_coord| estimate_moves(piece_coord, true) }.flatten.uniq # pawn_attack_only = true

      # Add to legal moves array if the move does not reveal own king to attack by the opponent
      legal_moves_array.push(coord) if opponent_attack_moves.include?(king_coord) == false

      # move piece back to original position, important if the piece is king
      # so the playerx_king_coord is updated
      @chess_board.move_piece(coord, starting_coord)
      # if a piece previously existed at coord, restore it
      @chess_board.set_piece_at_coord(coord, piece_at_coord) if piece_at_coord != nil
    end

    legal_moves_array
  end

  # Scan for opponent pieces using relative_moves of rook, bishop and knight
  # Need two different algos for rook,bishop vs knight because former doesn't jump, latter does jump
  # Return the coords of such pieces
  # Not all pieces are guaranteed to check the king. They are used as candidates for further determination
  def get_threatening_pieces(starting_coord, player_num = nil)
    piece = nil
    opponent_player_num = nil

    # the optional parameter of player_num is needed for now
    # TODO: refactor all get_threatening_pieces calls so player_num is specified, then remove default value of player_num and if/else statement
    if player_num.nil?
      piece = @chess_board.get_piece(starting_coord)
      player_num = piece.player_num
      opponent_player_num = piece.opponent_player_num
    else
      opponent_player_num = get_opponent_player_num(player_num)
    end

    possible_opponent_pieces_targeting_coord = possible_opponent_pieces_targeting_coord(starting_coord, player_num, opponent_player_num)

    # at this point, possible_opponent_pieces_targeting_coord
    # contains coords of possible opponent pieces that can attack
    # piece at starting_coord

    # filter possible_opponent_pieces_targeting_coord to get only the
    # pieces that have a move equal to starting_coord
    # only get the opponent pieces that attack starting_coord
    opponent_pieces_targeting_coord = []
    possible_opponent_pieces_targeting_coord.each do |opponent_coord|
      # pawn_attack_only = true
      possible_opponent_moves = estimate_moves(opponent_coord, true)
      opponent_pieces_targeting_coord << opponent_coord if possible_opponent_moves.include?(starting_coord)
    end

    opponent_pieces_targeting_coord
  end

  def possible_opponent_pieces_targeting_coord(starting_coord, player_num, opponent_player_num)
    # TODO: figure out how to get Ruby static variables working
    # get the relative moves
    rook = Rook.new(1)
    bishop = Bishop.new(1)
    knight = Knight.new(1)

    # assemble relative moves of three types of moves. These moves are used to find candidates of threatening pieces
    # Rook - covers attack moves of king, queen
    # Bishop - covers the attack moves of a pawn, queen
    # Knight - only piece that jumps, so it is considered separately
    rook_bishop_relative_moves = rook.relative_moves + bishop.relative_moves
    knight_relative_moves = knight.relative_moves

    # Covert relative moves to absolute moves on the board
    # note: moves off the board are converted to nil
    rook_bishop_absolute_moves = rook_bishop_relative_moves.map do |subarray|
      subarray.map { |relative_move| convert_relative_to_absolute(starting_coord, relative_move) }
    end

    knight_absolute_moves = knight_relative_moves.map { |relative_move| convert_relative_to_absolute(starting_coord, relative_move) }

    possible_opponent_pieces_targeting_coord = []

    # taken from #get_valid_rook_moves. Crucial difference is that a valid move is ONLY one that attacks an opponent piece
    rook_bishop_absolute_moves.each do |subarray|
      subarray.each do |absolute_move|
        break if absolute_move.nil? # stop subarray iteration if the move is off the board
        break if @chess_board.coord_contains_piece?(absolute_move) && @chess_board.get_piece(absolute_move).player_num == player_num # stop iteration if come across own player's piece

        # (1) If it contains an opponent piece, add to valid moves and break out of subarray iteration 
        if @chess_board.coord_contains_piece?(absolute_move) && @chess_board.get_piece(absolute_move).player_num == opponent_player_num
          possible_opponent_pieces_targeting_coord << absolute_move
          break
        end
      end
    end

    # taken from #get_valid_knight_moves. Crucial difference is that a valid move is ONLY one that attacks an opponent piece
    knight_absolute_moves.each do |absolute_move|
      if @chess_board.coord_contains_piece?(absolute_move) && @chess_board.get_piece(absolute_move).player_num == opponent_player_num
        possible_opponent_pieces_targeting_coord << absolute_move
      end
    end

    possible_opponent_pieces_targeting_coord
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

  def get_opponent_player_num(player_num)
    player_num == 1 ? 2 : 1
  end

  # for a certain player:
  # return true if all pieces have no moves left
  # return false if any piece has at least one valid move
  # for determining stalemate in ChessGame
  def no_valid_moves?(player_num)

    # boolean no_valid_moves = true by default
    no_valid_moves = true

    # iterate through @chess_board.board coords (key, not value) and run #valid_moves
    @chess_board.board.each do |coord, piece|
      next if piece == @chess_board.blank_value
      next if piece.player_num != player_num

      moves = valid_moves(coord)
      if moves == []
        next
      else
        # if any iterations return valid_moves that are not =[], switch to false
        no_valid_moves = false
        break # stop iteration for efficiency
      end
    end

    no_valid_moves
  end

  def promotable?(coord)
    piece = @chess_board.get_piece(coord)
    player_num = piece.player_num

    # Check is piece is a Pawn
    return false unless piece.instance_of?(Pawn)

    # check if the player's pawn has made it to the end
    row = coord[1].to_i
    return true if player_num == 1 && row == 8
    return true if player_num == 2 && row == 1

    false
  end
end