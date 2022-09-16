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

class ChessGame
  attr_accessor :board # remove, for debugging only

  def initialize
    @active_player = 1 # Player 1 always starts the game
    @player1_input = nil
    @player1_active_piece = nil
    @player1_active_piece_coord = nil
    @player2_input = nil
    @player2_active_piece = nil
    @player1_active_piece_coord = nil
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
    # Ask player to choose a valid piece
    # List valid moves of piece (give an opportunity to choose another piece)
    # Ask player to chose a valid move for piece
    # Move piece
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

    selected_piece = @board.get_piece(verified_start_coord)

    case
      when player_num == 1
        @player1_active_piece = selected_piece
      when player_num == 2
        @player2_active_piece = selected_piece
      else
        'Input Error!'
    end

    puts "You selected #{selected_piece.class} at #{verified_start_coord}"
  end

  # List valid moves of piece 
  # TODO: (give an opportunity to choose another piece)
  def list_moves(player_num)
    active_piece = nil
    active_piece_coord = nil
    
    case
      when player_num == 1
        active_piece = @player1_active_piece
        active_piece_coord = @player1_active_piece_coord
      when player_num == 2
        active_piece = @player2_active_piece
        active_piece_coord = @player2_active_piece_coord
      else
        'Input Error!'
    end

    # get all moves from piece object
    # ask board object which moves are valid
    # print these moves and well as store them for subsequent user choice

  end

  # Ask player to chose a valid move for piece
  # Move piece
  def move_piece(player_num)

  end

  def player_input
    gets.chomp
  end

  def verify_start_coord(start_coord, player_num)
    start_coord = start_coord.to_s

    # check if coordinate exists on the board
    piece_at_coord = @board.get_piece(start_coord)
    return nil if piece_at_coord.nil?

    # check if piece exists at the coord
    return nil if piece_at_coord == @board.blank_value
    
    # check if piece belongs to player
    piece_player = piece_at_coord.player
    return nil if piece_player != player_num

    start_coord
  end
  
  # Switch the active player between 1 and 2
  def toggle_active_player
    if @active_player == 1
      @active_player = 2
    else
      @active_player = 1
    end
  end

  def game_over?
    true
  end

  # call a ChessBoard method here
  def print_board
    @board.print_board
  end
end