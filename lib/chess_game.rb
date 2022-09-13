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

require '../lib/chess_board'

class ChessGame
  attr_accessor :board # remove, for debugging only

  def initialize
    @active_player = 1
    @player1_input = nil
    @player2_input = nil
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

  def enter_start_coord(player_num)
    puts "Player #{player_num} enter coordinate of piece to move: "
    
    verified_start_coord = ''
    verified_piece_at_coord = ''
    loop do
      verified_start_coord = verify_start_coord(player_input, player_num)

      break if verified_start_coord # break if not nil

      puts 'Input Error!'
    end

    puts "You selected piece_name at #{verified_start_coord}"
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
    puts "Print the chess board"
  end
end

game = ChessGame.new
game.enter_start_coord(1)

board = game.board
# p board.get_piece("a1")
# p board.get_piece("a3")