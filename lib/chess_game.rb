# User selects chess piece
# Game provides list of legal moves (different based on piece type)
# User choses a legal move
# Game moves piece and removes opposing player's piece if needed

# Legal moves
# Player can only move one's pieces
# Moves that intersect with own pieces are not listed (exception: castling)
# Moves that capture an enemy piece are listed (some extra boundaries based on chess piece, like a rook can't jump over a piece while knight can)

# Legal moves by piece
# King - one square in any direction (+ castling)
# Rook - move along rank or file, cannot jump, (+ castling)
# Bishop - move diagonally, cannot jump
# Queen - Rook + Bishop
# Knight - (+ or -) 1/2 or 2/1, CAN jump
# Pawn - Moves one forward or two forward if first move. Can only capture pieces one diagonally. En passant and promotion

# Game over conditions
# Check - King is under threat, player must only move the king next turn
# Checkmate - King is under threat and has no moves
# Player resign

# Esoteric moves (implement later)
# Castling between King and Rook
# - not a legal response to a check
# En Passant between two pawns
# promotion of a pawn that reaches the eigth rank (row)

# Game over - Draw (implement later)
# Stalemate - player has no legal move and not in check
# Dead position - neither player is able to checkmate. Such as only two kings are on the board (research all possibilities - hope its a short list)
# Draw by agreement - can only be offered after move 30. Implementation not needed
# Threefold repetition - situation too esoteric
# Fifty-move-rule - situation too esoteric

# pieces are denoted by the file its in such as "pawn in f-file"

require_relative '../lib/chess_board'
require 'pry-byebug'

class ChessGame
  attr_accessor :board # remove, for debugging only

  def initialize
    @active_player = 1 # Player 1 always starts the game
    
    @player_num = nil
    @player_starting_coord = nil
    @player_valid_moves = []
    @player_ending_coord = nil
    @player_redo_selection = true

    @board = ChessBoard.new
  end

  def play_game
    puts "Greeting message"
    print_board
    turn_order until game_over?
    puts "Final message"
  end

  def turn_order
    player_turn(@active_player)
    print_board
    toggle_active_player
  end

  def player_turn(active_player)
    while @player_redo_selection == true
      # Ask player to choose a valid piece
      select_piece(active_player)
      # List valid moves of piece (give an opportunity to choose another piece)
      print_moves
      # Ask player to chose a valid move for piece
      choose_move(active_player)
    end
    # Move piece
    move_piece
    @player_redo_selection = true # reset back to default value to prevent an infinite loop
  end

  # TODO: Learn how to throw errors
  def select_piece(player_num)
    puts "Player #{player_num} enter coordinate of piece to move: "
    
    verified_start_coord = ''
    loop do
      raw_input = player_input
      verified_start_coord = verify_start_coord(raw_input, player_num)

      break if verified_start_coord # break if not nil

      puts 'Input Error!'
    end

    @player_starting_coord = verified_start_coord

    selected_piece = @board.get_piece(verified_start_coord)
    puts "You selected #{selected_piece.class} at #{verified_start_coord}"
  end

  def verify_start_coord(start_coord, player_num)
    start_coord = start_coord.to_s

    # check if coordinate exists on the board
    piece_at_coord = @board.get_piece(start_coord)
    return nil if piece_at_coord.nil?

    # check if piece exists at the coord
    return nil if piece_at_coord == @board.blank_value
    
    # check if piece belongs to player
    piece_player_num = piece_at_coord.player_num
    return nil if piece_player_num != player_num

    # check if piece has any available moves
    return nil if board.get_valid_moves(start_coord) == []

    start_coord
  end

  # List valid moves of piece 
  # TODO: (give an opportunity to choose another piece)
  def print_moves

    # get the valid moves of the piece at selected coord
    # store moves for subsequent user choice
    @player_valid_moves = board.get_valid_moves(@player_starting_coord)

    @board.print_board(@player_starting_coord, @player_valid_moves)

    # print moves for user
    p @player_valid_moves
  end

  def choose_move(player_num)
    puts "Player #{player_num} enter a move: "
    puts "Enter R to choose a different piece"
    
    verified_move = ''
    loop do
      raw_input = player_input
      verified_move = verify_move_choice(raw_input, player_num)

      break if verified_move # break if not nil

      puts 'Input Error!'
    end

    @player_ending_coord = verified_move

    puts "Player #{player_num} chose #{verified_move}"
  end

  def verify_move_choice(move_choice, player_num)
    # if a move is chosen, the player doesn't want to choose another piece
    if @player_valid_moves.include?(move_choice)
      @player_redo_selection = false
      return move_choice
    # if "R" is chosen, the player wants to redo their choice
    elsif move_choice.upcase == 'R'
      @player_redo_selection = true
      return move_choice
    end

    # return move_choice if @player_valid_moves.include?(move_choice)

    # return move_choice if move_choice.upcase == 'R'

    nil
  end

  # Ask player to chose a valid move for piece
  # Move piece
  def move_piece
    board.move_piece(@player_starting_coord, @player_ending_coord)
  end

  def player_input
    gets.chomp
  end
  
  # Switch the active player between 1 and 2
  def toggle_active_player
    if @active_player == 1
      @active_player = 2
    else
      @active_player = 1
    end
  end

  # Game over conditions
  # Player resign - player is able to enter option during piece choice
  # Checkmate
  # Stalemate - player has no legal move and not in check
  # Dead position - neither player is able to checkmate. Such as only two kings are on the board (research all possibilities - hope its a short list)

  def game_over?
    false
  end


  # When a king is under immediate attack, it is said to be in check. A move in response to a check is legal only if it results in a position where the king is no longer in check. This can involve capturing the checking piece; interposing a piece between the checking piece and the king (which is possible only if the attacking piece is a queen, rook, or bishop and there is a square between it and the king); or moving the king to a square where it is not under attack. Castling is not a permissible response to a check

  # The object of the game is to checkmate the opponent; this occurs when the opponent's king is in check, and there is no legal way to get it out of check. It is never legal for a player to make a move that puts or leaves the player's own king in check

  def check_player1?
    threatening_pieces = []
    possible_threatening_pieces_targeting_p1 = board.get_threatening_pieces(@board.player1_king_coord)

    player2_possible_attack_moves = possible_threatening_pieces_targeting_p1.map { |piece_coord| board.get_valid_moves(piece_coord, true) }.flatten # pawn_attack_only = true

    return true if player2_possible_attack_moves.include?(@board.player1_king_coord)

    false
  end

  def check_player2?
    threatening_pieces = []
    possible_threatening_pieces_targeting_p2 = board.get_threatening_pieces(@board.player2_king_coord)

    player1_possible_attack_moves = possible_threatening_pieces_targeting_p2.map { |piece_coord| board.get_valid_moves(piece_coord, true) }.flatten # pawn_attack_only = true

    return true if player1_possible_attack_moves.include?(@board.player2_king_coord)

    false
  end

  # Checkmate - King is under threat. King may have valid_moves but they all lead to the king being captured
  # Need to know the location of both kings are at all times
  # From a king position, scan for opponent pieces similar to get_valid_moves (using a relative_moves check) for rook, bishop, queen, knight, pawn/king. All opponent piece coords that satisfy this condition go into an array. Check each piece with get_valid_moves to double check that these pieces can directly attack the king
  # if no pieces can attack the king, the player is not in check or checkmate
  # if a piece can attack the king, but it can flee into a safe position, the player is in check
  # if a piece can attack the king and it cannot flee into a safe position, the player is in checkmate and the game is over

      # problem here. What of pawn moves? They need to be considered separately. A pawn is different in that its "regular moves" and "attack moves" are different
    # If this isn't considered, a game state can be falsely determined to have a checkmate from a pawn moving forward but not attacking
    # idea 1: create a param in board.get_valid_moves that if used on a pawn, calls a different method that only returns attack moves
  def checkmate?




  end

  # call a ChessBoard method here
  def print_board
    @board.print_board
  end
end