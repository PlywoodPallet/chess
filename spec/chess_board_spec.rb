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

  # #get_valid_pawn_moves
  # each test needs to be tested for player 1 and 2
  # pawn can only move forward based on player
  # when pawn is on home row, it can move one or two squares forward
  # pawn can attack opponent piece diagonally
  # pawn cannot attack diagonally if piece is owned by the same player
  # Note: to debug test use board.print_board to print the state of the board
  # TODO: add tests once #get_valid_pawn_moves TODO's are finished (additional functionality)
  describe '#get_valid_pawn_moves' do
    context 'player 1' do
      subject(:board) { described_class.new }
      
      it 'pawn can only move forward' do
        board.move_piece('a2', 'a3') # move a pawn out of home row
        pawn_moves = board.get_valid_pawn_moves('a3')

        expect(pawn_moves).to eq(['a4'])
      end

      it 'when pawn is in home row, it can move one or two square forward' do
        pawn_moves = board.get_valid_pawn_moves('b2')

        expect(pawn_moves).to eq(['b3','b4'])
      end

      it 'in addition to regular moves, pawn can attack opponent piece diagonally if available' do
        board.move_piece('e7', 'e3') # move opponent piece into position
        pawn_moves = board.get_valid_pawn_moves('f2')

        expect(pawn_moves).to eq(['f3','f4','e3']) # returns regular moves first, then attack moves
        
      end

      it 'pawn cannot attack own piece diagonally' do
        board.move_piece('d2', 'd3') # move own piece into position
        pawn_moves = board.get_valid_pawn_moves('c2')

        expect(pawn_moves).to eq(['c3','c4']) 
      end
    end

    context 'player 2' do
      subject(:board) { described_class.new }

      it 'pawn can only move forward' do
        board.move_piece('a7', 'a6') # move a pawn out of home row
        pawn_moves = board.get_valid_pawn_moves('a6')

        expect(pawn_moves).to eq(['a5'])
        
      end

      it 'when pawn is in home row, it can move one or two square forward' do
        pawn_moves = board.get_valid_pawn_moves('b7')

        expect(pawn_moves).to eq(['b6','b5'])
      end

      it 'in addition to regular moves, pawn can attack opponent piece diagonally if available' do
        board.move_piece('e2', 'e6') # move opponent piece into position
        pawn_moves = board.get_valid_pawn_moves('f7')

        expect(pawn_moves).to eq(['f6','f5','e6']) # returns regular moves first, then attack moves
      end

      it 'pawn cannot attack own piece diagonally' do
        board.move_piece('d7', 'd6') # move own piece into position
        pawn_moves = board.get_valid_pawn_moves('c7')

        expect(pawn_moves).to eq(['c6','c5'])
      end
    end
  end

  # test for player 1 and 2
  # test regular moves/does not go out of bounds
  # test attack moves on opponent's pieces
  # test that it cannot attack own pieces
  describe '#get_valid_knight_moves' do
    context 'player 1' do
      subject(:board) { described_class.new }

      it 'returns normal, non-attack moves and does not go out of bounds. It does not attack own pieces' do
        knight_moves = board.get_valid_knight_moves('b1')

        expect(knight_moves).to eq(['c3', 'a3'])
      end

      it 'returns attack moves onto opponents pieces in addition to normal moves' do
        board.move_piece('b1', 'c6') # move piece into position

        knight_moves = board.get_valid_knight_moves('c6')

        expect(knight_moves).to eq(['e5', 'd4', 'b4', 'a5', 'd8', 'e7', 'a7', 'b8'])
      end
    end

    context 'player 2' do
      subject(:board) { described_class.new }

      it 'returns normal, non-attack moves and does not go out of bounds. It does not attack own pieces' do 
        knight_moves = board.get_valid_knight_moves('b8')

        expect(knight_moves).to eq(['c6', 'a6'])
      end

      it 'returns attack moves onto opponents pieces in addition to normal moves' do
        board.move_piece('b8', 'c3') # move piece into position

        knight_moves = board.get_valid_knight_moves('c3')

        expect(knight_moves).to eq(['d5', 'e4', 'a4', 'b5', 'e2', 'd1', 'b1', 'a2'])
      end
    end
  end

  # test for player 1 and 2
  # test regular moves/does not go out of bounds
  # test attack moves on opponent's pieces
  # test that it cannot attack own pieces
  describe '#get_valid_rook_moves' do
    context 'player 1' do
      subject(:board) { described_class.new }

      it 'moves in rows and columns, does not go out of bounds, attacks opponent pieces and does not attack friendly pieces' do
        board.move_piece('a1', 'd4')

        rook_moves = board.get_valid_rook_moves('d4')

        # attacks opponent piece: d7
        # does not attack friendly piece: d2 not on the list
        expect(rook_moves).to eq(['e4', 'f4', 'g4', 'h4', 'd5', 'd6', 'd7', 'c4', 'b4', 'a4', 'd3'])
      end

    end
    context 'player 2' do
      subject(:board) { described_class.new }

      it 'moves in rows and columns, does not go out of bounds, attacks opponent pieces and does not attack friendly pieces' do
        board.move_piece('a8', 'd4')

        rook_moves = board.get_valid_rook_moves('d4')

        # attacks opponent piece: d2
        # does not attack friendly piece: d7 not on the list
        expect(rook_moves).to eq(['e4', 'f4', 'g4', 'h4', 'd5', 'd6', 'c4', 'b4', 'a4', 'd3', 'd2'])
      end
    end
  end

  # test for player 1 and 2
  # test regular moves/does not go out of bounds
  # test attack moves on opponent's pieces
  # test that it cannot attack own pieces
  describe '#get_valid_bishop_moves' do
    context 'player 1' do
      subject(:board) { described_class.new }

      it 'moves in rows and columns, does not go out of bounds, attacks opponent pieces and does not attack friendly pieces' do
        board.move_piece('c1', 'd4')

        bishop_moves = board.get_valid_bishop_moves('d4')

        # attacks opponent piece: a7, g7
        # does not attack friendly piece: b2,f2 ommitted
        expect(bishop_moves).to eq(['e5', 'f6', 'g7', 'e3', 'c3', 'c5', 'b6', 'a7'])
      end

    end
    context 'player 2' do
      subject(:board) { described_class.new }

      it 'moves in rows and columns, does not go out of bounds, attacks opponent pieces and does not attack friendly pieces' do
        board.move_piece('c8', 'd4')

        bishop_moves = board.get_valid_bishop_moves('d4')

        # attacks opponent piece: f2, b2
        # does not attack friendly piece: a7, g7 ommitted
        expect(bishop_moves).to eq(['e5', 'f6', 'e3', 'f2', 'c3', 'b2', 'c5', 'b6'])
      end
    end
  end
end