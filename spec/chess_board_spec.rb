# Accomplishments
# Created my first custom matcher for #get_piece test in spec_helper.rb called "be_the_same_chess_piece_as"

# NOTE: player 1 and player 2 tests are no longer neccessary for methods refactored to be player_num agnostic

require_relative '../lib/chess_board.rb'
require_relative '../lib/chess_piece.rb'

describe ChessBoard do 

  # Method has no error checking, test this feature in higher level methods
  # TODO: currently code is repeated. Figure out how to repeat the test twice with the same code, and for their variables to be accessed by each test
  describe '#move_piece(start_coord, end_coord)' do
    context 'Given a starting board, move a piece from start_coord to end_coord' do 
      subject(:board) { described_class.new }

      it 'start_coord contains moved piece' do
        start_coord = 'a2' # white pawn
        end_coord = 'a3'
        piece = board.get_piece(start_coord)
        
        board.move_piece(start_coord, end_coord)

        start_piece = board.get_piece(start_coord) # this location should be empty after move
        end_piece = board.get_piece(end_coord)

        expect(piece).to eql(end_piece)
      end

      it 'end_coord contains a blank value' do 
        start_coord = 'a2' # white pawn
        end_coord = 'a3'
        piece = board.get_piece(start_coord)
        
        board.move_piece(start_coord, end_coord)

        start_piece = board.get_piece(start_coord) # this location should be empty after move
        end_piece = board.get_piece(end_coord)

        expect(start_piece).to eq(board.blank_value)
      end

      it 'when king is moved, it stores its new coordinate' do
        start_coord = 'e1' # player 1 king
        end_coord = 'a3'

        piece = board.get_piece(start_coord)

        board.move_piece(start_coord, end_coord)

        expect(board.player1_king_coord).to eq(end_coord)
      end
    end
  end

  # this test may also need to be performed on higher level functions
  describe '#get_piece(coord)' do 
    subject(:board) { described_class.new }

    it 'if piece at coordinate exists, return the piece' do
      expected_piece = Pawn.new(1)
      retrieved_piece = board.get_piece("a2") # pawn in this location on starting board

      expect(retrieved_piece).to be_the_same_chess_piece_as(expected_piece)
    end

    it 'if piece is off the board, return nil' do
      retrieved_piece = board.get_piece("z22") # location off the board

      expect(retrieved_piece).to be_nil
    end

    it 'if the coordinate has no piece, return blank value' do 
      retrieved_piece = board.get_piece("a5") # location with no piece

      expect(retrieved_piece).to eq(board.blank_value)
    end
  end
end