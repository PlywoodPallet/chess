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
require_relative '../lib/move_validator'
require_relative '../lib/serializable'

class ChessGame
  include Serializable

  attr_accessor :chess_board

  def initialize
    @active_player = 1 # Player 1 always starts the game
    
    @player_starting_coord = nil
    @player_valid_moves = []
    @player_ending_coord = nil
    @player_redo_selection = true
    @game_over_condition = nil
    @player_save_game = false

    @chess_board = ChessBoard.new
    @move_validator = MoveValidator.new(@chess_board)
  end

  def play_game
    # if this is a restored saved game, reset this var so the game doesn't immediately end
    @player_save_game = false if @player_save_game == true
    # print starting board
    print_board
    # keep playing the game until the game is over or player chooses to save game
    turn_order until game_over?(@active_player) || @player_save_game == true
    print_final_message
  end

  def print_final_message
    # @active_player is loser due to #turn_order, toggle so it is the winner
    toggle_active_player(@active_player) if @game_over_condition == 'Checkmate'

    # Print game_over_condition and winner. Do not print anything if game is being saved
    puts "#{@game_over_condition}! Player #{@active_player} wins" unless @player_save_game == true
  end

  def turn_order
    player_turn(@active_player)
    print_board
    toggle_active_player(@active_player)
  end

  def player_turn(active_player)
    while @player_redo_selection == true
      # Ask player to choose a valid piece
      select_piece(active_player, check?(active_player))

      # Stop player turn if the player chooses to resign or save
      break if @game_over_condition == 'Resigned'
      if @player_save_game == true
        save_game
        break
      end

      # List valid moves of piece
      print_moves(active_player, check?(active_player))
      # Ask player to chose a valid move for piece (give an opportunity to choose another piece)
      choose_move(active_player, check?(active_player))

      # redudant, if resign chosen then @player_redo_selection == false
      # break if @game_over_condition == 'Resigned'
    end

    # Prevent piece selection if the player has resigned or chosen to save the game
    unless @game_over_condition == 'Resigned' || @player_save_game == true
      # Move piece
      move_piece 
      pawn_promotion(@active_player) if @move_validator.promotable?(@player_ending_coord)
    end
    @player_redo_selection = true # reset back to default value for the next player
  end

  # Function: Skips piece selection when player is under check. Moving the king is the only legal move
  def select_piece(player_num, check = false)
    verified_start_coord = ''

    # only ask player to choose a piece if they are NOT under check
    if check == false
      loop do
        puts "Player #{player_num} enter coordinate of piece to move: "
        puts 'Enter RESIGN to end the game'
        puts 'Enter SAVE to save and quit the game'

        raw_input = player_input
        verified_start_coord = verify_start_coord(raw_input)

        # break if not nil AND if piece at coord has moves
        break if verified_start_coord && verified_start_coord != 'nomoves'

        system('clear')
        print_board
        print 'Input Error! '
        puts 'Piece has no valid moves' if verified_start_coord == 'nomoves'
      end
    # if player is under check, skip piece selection and chose their king
    elsif check == true && player_num == 1
      verified_start_coord = @chess_board.player1_king_coord
    elsif check == true && player_num == 2
      verified_start_coord = @chess_board.player2_king_coord
    end

    @player_starting_coord = verified_start_coord
  end

  def verify_start_coord(start_coord)
    # this must be at the top because start_coord is not a valid piece
    if start_coord.upcase == 'RESIGN'
      @game_over_condition = 'Resigned'
      return start_coord # only used to stop the method here
    elsif start_coord.upcase == 'SAVE'
      @player_save_game = true
      return start_coord # only used to stop the method here
    end

    piece_at_coord = @chess_board.get_piece(start_coord)
    # check if coordinate exists on the board    
    return nil if piece_at_coord.nil?
    # check if piece exists at the coord
    return nil if piece_at_coord == @chess_board.blank_value
    # check if piece belongs to player
    piece_player_num = piece_at_coord.player_num
    return nil if piece_player_num != @active_player

    # check if piece has any available moves
    return 'nomoves' if @move_validator.valid_moves(start_coord) == []

    start_coord
  end

  # List valid moves of piece 
  def print_moves(active_player, check = false)
    system('clear')

    # if under check, change  @player_starting_coord points the current player's king
    @player_starting_coord = get_king_coord_of_player(active_player) if check == true

    # #valid_moves works for king under check, as well as all other pieces
    # get_king_moves_under_check is depreciated
    @player_valid_moves = @move_validator.valid_moves(@player_starting_coord)
    # the simpler method print_board exists, but I want to show explicitly which parameters are being used
    @chess_board.print_board(@player_starting_coord, @player_valid_moves)
  end

  def choose_move(player_num, check = false)
    # if under check, declare it to user
    print 'Check! ' if check == true

    puts "Player #{player_num} enter a move: #{@player_valid_moves}"
    # do not allow player to redo selection if under check
    puts 'Enter REDO to choose a different piece' unless check == true
    # if player is under check, allow player to resign (was skipped in #select_piece)
    puts 'Enter RESIGN to end the game' if check == true
    
    verified_move = ''
    loop do
      raw_move = player_input
      verified_move = verify_move_choice(raw_move)

      break if verified_move # break if not nil

      puts 'Input Error!'
    end

    system("clear")

    @player_ending_coord = verified_move
    puts "Player #{player_num} chose #{verified_move}"
  end

  def verify_move_choice(move_choice)
    if move_choice.upcase == 'RESIGN'
      @game_over_condition = 'Resigned'
      @player_redo_selection = false
      return move_choice # only used to stop the method here
    # if "REDO" is chosen, the player wants to redo their choice
    # this is only valid if player is not under check
    elsif move_choice.upcase == 'REDO' && check?(@active_player) == false
      @player_redo_selection = true
      return move_choice
    # if a valid move is chosen, the player doesn't want to choose another piece
    elsif @player_valid_moves.include?(move_choice.downcase)
      @player_redo_selection = false
      return move_choice
    end

    nil
  end

  # Move piece chosen piece to end
  def move_piece
    @chess_board.move_piece(@player_starting_coord, @player_ending_coord)
  end

  def pawn_promotion(active_player)
    puts "Promote Pawn in #{@player_ending_coord}"
    puts "Enter a piece to promote to (Queen, Knight, Rook, Bishop):"

    promotion_choice = ''
    loop do
      promotion_choice = verify_promotion_choice(player_input)

      break if promotion_choice # break if not nil

      puts 'Input Error!'
    end

    piece = nil
    case promotion_choice.upcase
    when 'QUEEN'
      piece = Queen.new(active_player)
    when 'KNIGHT'
      piece = Knight.new(active_player)
    when 'ROOK'
      piece = Rook.new(active_player)
    when 'BISHOP'
      piece = Bishop.new(active_player)
    else
      puts 'Error in piece promotion'
    end

    system("clear")

    @chess_board.set_piece_at_coord(@player_ending_coord, piece)
    puts "Pawn in #{@player_ending_coord} was promoted to #{piece.class}"
  end

  def verify_promotion_choice(player_input)
    valid_promotion_choices = ['QUEEN', 'KNIGHT', 'ROOK', 'BISHOP']

    return player_input if valid_promotion_choices.include?(player_input.upcase)

    nil
  end

  # get player input then convert to string
  def player_input
    gets.chomp.to_s
  end
  
  # Switch the active player between 1 and 2
  def toggle_active_player(active_player)
    @active_player = 2 if active_player == 1
    @active_player = 1 if active_player == 2
  end

  # Game over conditions
  # Player resign - player is able to enter option during piece choice
  # Checkmate
  # Stalemate - player has no legal move and not in check
  # SKIP IMPLEMENTATION: Dead position - neither player is able to checkmate. Such as only two kings are on the board (research all possibilities - hope its a short list)


  def game_over? (active_player)
    return true if @game_over_condition == 'Resigned'
    
    if checkmate?(active_player)
      @game_over_condition = 'Checkmate'
      return true
    end

    if stalemate?(active_player)
      @game_over_condition = 'Stalemate'
      return true
    end

    false
  end

  # When a king is under immediate attack, it is said to be in check. A move in response to a check is legal only if it results in a position where the king is no longer in check. This can involve capturing the checking piece; interposing a piece between the checking piece and the king (which is possible only if the attacking piece is a queen, rook, or bishop and there is a square between it and the king); or moving the king to a square where it is not under attack. Castling is not a permissible response to a check

  # The object of the game is to checkmate the opponent; this occurs when the opponent's king is in check, and there is no legal way to get it out of check. It is never legal for a player to make a move that puts or leaves the player's own king in check
  def check?(active_player)
    king_coord = get_king_coord_of_player(active_player)

    opponent_pieces_targeting_king = @move_validator.get_threatening_pieces(king_coord, active_player)

    # pawn_attack_only = true
    opponent_attack_moves = opponent_pieces_targeting_king.map { |piece_coord| @move_validator.valid_moves(piece_coord, true) }.flatten.uniq 

    return true if opponent_attack_moves.include?(king_coord)

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

  def checkmate?(active_player)
    king_coord = get_king_coord_of_player(active_player)

    # pawn_attack_only = true
    valid_king_moves = @move_validator.valid_moves(king_coord, true)
    check?(active_player)

    # king must be under threat AND have no valid moves left
    return true if valid_king_moves == [] && check?(active_player)

    false
  end

  # Stalemate - both players have no legal moves and neither are under check
  def stalemate?(active_player)
    # if #check is false and no_valid_moves = true, return true
    return true if check?(active_player) == false && @move_validator.no_valid_moves?(active_player)
    
    false
  end

  # call ChessBoard methods here
  
  def print_board
    @chess_board.print_board
  end

  def get_king_coord_of_player(player_num)
    @chess_board.get_king_coord_of_player(player_num)
  end
end