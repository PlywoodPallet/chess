# Accomplishments
# Created my first custom matcher for #get_piece test in spec_helper.rb called "be_the_same_chess_piece_as"

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

  # convert_relative_to_absolute
  # cases: (1) relative_coord leads to a valid square, (2) relative_coord leads to invalid square (return nil)
  # assume starting_cord is valid. If its invalid the issue is with the method that calls it, not this method
  describe '#convert_relative_to_absolute' do 
    subject(:board) { described_class.new }

    it 'when relative coordinate leads to a valid square, return the resulting absolute coordinate' do 
      starting_coord = 'e2'
      relative_coord = [0,2]
      
      new_coord = board.convert_relative_to_absolute(starting_coord, relative_coord)

      expect(new_coord).to eq('e4')
    end

    it 'when relative coordinate goes off the board, return nil' do 
      starting_coord = 'a2'
      relative_coord = [-1,0]
      
      new_coord = board.convert_relative_to_absolute(starting_coord, relative_coord)

      expect(new_coord).to be_nil
    end
  end

  # get_valid_pawn_moves





end