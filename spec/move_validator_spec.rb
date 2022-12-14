require_relative '../lib/move_validator'
require_relative '../lib/chess_board'
require_relative '../lib/chess_piece'

describe MoveValidator do

    # convert_relative_to_absolute
  # cases: (1) relative_coord leads to a valid square, (2) relative_coord leads to invalid square (return nil)
  # assume starting_cord is valid. If its invalid the issue is with the method that calls it, not this method
  describe '#convert_relative_to_absolute' do 
    let(:board) { ChessBoard.new }
    subject(:validator) { described_class.new(board) }
    

    it 'when relative coordinate leads to a valid square, return the resulting absolute coordinate' do 
      starting_coord = 'e2'
      relative_coord = [0,2]
      
      new_coord = validator.convert_relative_to_absolute(starting_coord, relative_coord)

      expect(new_coord).to eq('e4')
    end

    it 'when relative coordinate goes off the board, return nil' do 
      starting_coord = 'a2'
      relative_coord = [-1,0]
      
      new_coord = validator.convert_relative_to_absolute(starting_coord, relative_coord)

      expect(new_coord).to be_nil
    end
  end

  # #estimate_pawn_moves
  # each test needs to be tested for player 1 and 2
  # pawn can only move forward based on player
  # when pawn is on home row, it can move one or two squares forward
  # pawn can attack opponent piece diagonally
  # pawn cannot attack diagonally if piece is owned by the same player
  # Note: to debug test use board.print_board to print the state of the board
  # TODO: add tests once #estimate_pawn_moves TODO's are finished (additional functionality)
  describe '#estimate_pawn_moves' do
    context 'player 1' do
      let(:board) { ChessBoard.new }
      subject(:validator) { described_class.new(board) }
      
      it 'pawn can only move forward' do
        board.move_piece('a2', 'a3') # move a pawn out of home row
        pawn_moves = validator.estimate_pawn_moves('a3')

        expect(pawn_moves).to eq(['a4'])
      end

      it 'when pawn is in home row, it can move one or two square forward' do
        pawn_moves = validator.estimate_pawn_moves('b2')

        expect(pawn_moves).to eq(['b3','b4'])
      end

      it 'in addition to regular moves, pawn can attack opponent piece diagonally if available' do
        board.move_piece('e7', 'e3') # move opponent piece into position
        pawn_moves = validator.estimate_pawn_moves('f2')

        expect(pawn_moves).to eq(['f3','f4','e3']) # returns regular moves first, then attack moves
        
      end

      it 'pawn cannot attack own piece diagonally' do
        board.move_piece('d2', 'd3') # move own piece into position
        pawn_moves = validator.estimate_pawn_moves('c2')

        expect(pawn_moves).to eq(['c3','c4']) 
      end

      it 'pawn cannot move forward if blocked by own piece' do
        board.move_piece('a2', 'b3')
        pawn_moves = validator.estimate_pawn_moves('b2')

        expect(pawn_moves).to eq([]) 
      end

      it 'pawn cannot move forward if blocked by opponent piece' do
        board.move_piece('a7', 'b3')
        pawn_moves = validator.estimate_pawn_moves('b2')

        expect(pawn_moves).to eq([]) 
      end

      # method refactored to be player_num agnostic, player 2 test unnecessary
      it 'when optional param pawn_attack_only = true, return the attack moves only' do
        board.move_piece('b7','b3') # move opponent piece as target
        pawn_moves = validator.estimate_pawn_moves('a2', true)

        expect(pawn_moves).to eq(['b3'])
      end
    end

    context 'player 2' do
      let(:board) { ChessBoard.new }
      subject(:validator) { described_class.new(board) }

      it 'pawn can only move forward' do
        board.move_piece('a7', 'a6') # move a pawn out of home row
        pawn_moves = validator.estimate_pawn_moves('a6')

        expect(pawn_moves).to eq(['a5'])
      end

      it 'when pawn is in home row, it can move one or two square forward' do
        pawn_moves = validator.estimate_pawn_moves('b7')

        expect(pawn_moves).to eq(['b6','b5'])
      end

      it 'in addition to regular moves, pawn can attack opponent piece diagonally if available' do
        board.move_piece('e2', 'e6') # move opponent piece into position
        pawn_moves = validator.estimate_pawn_moves('f7')

        expect(pawn_moves).to eq(['f6','f5','e6']) # returns regular moves first, then attack moves
      end

      it 'pawn cannot attack own piece diagonally' do
        board.move_piece('d7', 'd6') # move own piece into position
        pawn_moves = validator.estimate_pawn_moves('c7')

        expect(pawn_moves).to eq(['c6','c5'])
      end

      it 'pawn cannot move forward if blocked by own piece' do
        board.move_piece('a7', 'b6')
        pawn_moves = validator.estimate_pawn_moves('b7')

        expect(pawn_moves).to eq([]) 
      end

      it 'pawn cannot move forward if blocked by opponent piece' do
        board.move_piece('a2', 'b6')
        pawn_moves = validator.estimate_pawn_moves('b7')

        expect(pawn_moves).to eq([]) 
      end
    end
  end

  # test for player 1 and 2
  # test regular moves/does not go out of bounds
  # test attack moves on opponent's pieces
  # test that it cannot attack own pieces
  describe '#estimate_knight_moves' do
    context 'player 1' do
      let(:board) { ChessBoard.new }
      subject(:validator) { described_class.new(board) }

      it 'returns normal, non-attack moves and does not go out of bounds. It does not attack own pieces' do
        knight_moves = validator.estimate_knight_moves('b1')

        expect(knight_moves).to eq(['c3', 'a3'])
      end

      it 'returns attack moves onto opponents pieces in addition to normal moves' do
        board.move_piece('b1', 'c6') # move piece into position

        knight_moves = validator.estimate_knight_moves('c6')

        expect(knight_moves).to eq(['e5', 'd4', 'b4', 'a5', 'd8', 'e7', 'a7', 'b8'])
      end
    end

    context 'player 2' do
      let(:board) { ChessBoard.new }
      subject(:validator) { described_class.new(board) }

      it 'returns normal, non-attack moves and does not go out of bounds. It does not attack own pieces' do 
        knight_moves = validator.estimate_knight_moves('b8')

        expect(knight_moves).to eq(['c6', 'a6'])
      end

      it 'returns attack moves onto opponents pieces in addition to normal moves' do
        board.move_piece('b8', 'c3') # move piece into position

        knight_moves = validator.estimate_knight_moves('c3')

        expect(knight_moves).to eq(['d5', 'e4', 'a4', 'b5', 'e2', 'd1', 'b1', 'a2'])
      end
    end
  end

  # test for player 1 and 2
  # test regular moves/does not go out of bounds
  # test attack moves on opponent's pieces
  # test that it cannot attack own pieces
  describe '#estimate_rook_moves' do
    context 'player 1' do
      let(:board) { ChessBoard.new }
    subject(:validator) { described_class.new(board) }

      it 'moves in rows and columns, does not go out of bounds, attacks opponent pieces and does not attack friendly pieces' do
        board.move_piece('a1', 'd4')

        rook_moves = validator.estimate_rook_moves('d4')

        # attacks opponent piece: d7
        # does not attack friendly piece: d2 not on the list
        expect(rook_moves).to eq(['e4', 'f4', 'g4', 'h4', 'd5', 'd6', 'd7', 'c4', 'b4', 'a4', 'd3'])
      end

    end
    context 'player 2' do
      let(:board) { ChessBoard.new }
      subject(:validator) { described_class.new(board) }

      it 'moves in rows and columns, does not go out of bounds, attacks opponent pieces and does not attack friendly pieces' do
        board.move_piece('a8', 'd4')

        rook_moves = validator.estimate_rook_moves('d4')

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
  describe '#estimate_bishop_moves' do
    context 'player 1' do
      let(:board) { ChessBoard.new }
      subject(:validator) { described_class.new(board) }

      it 'moves in rows and columns, does not go out of bounds, attacks opponent pieces and does not attack friendly pieces' do
        board.move_piece('c1', 'd4')

        bishop_moves = validator.estimate_bishop_moves('d4')

        # attacks opponent piece: a7, g7
        # does not attack friendly piece: b2,f2 ommitted
        expect(bishop_moves).to eq(['e5', 'f6', 'g7', 'e3', 'c3', 'c5', 'b6', 'a7'])
      end

    end
    context 'player 2' do
      let(:board) { ChessBoard.new }
      subject(:validator) { described_class.new(board) }

      it 'moves in rows and columns, does not go out of bounds, attacks opponent pieces and does not attack friendly pieces' do
        board.move_piece('c8', 'd4')

        bishop_moves = validator.estimate_bishop_moves('d4')

        # attacks opponent piece: f2, b2
        # does not attack friendly piece: a7, g7 ommitted
        expect(bishop_moves).to eq(['e5', 'f6', 'e3', 'f2', 'c3', 'b2', 'c5', 'b6'])
      end
    end
  end

  # test for player 1 and 2
  # test regular moves/does not go out of bounds
  # test attack moves on opponent's pieces
  # test that it cannot attack own pieces
  describe '#estimate_queen_moves' do
    context 'player 1' do
      let(:board) { ChessBoard.new }
    subject(:validator) { described_class.new(board) }

      it 'moves in rows and columns, does not go out of bounds, attacks opponent pieces and does not attack friendly pieces' do
        board.move_piece('d1', 'd4')

        queen_moves = validator.estimate_queen_moves('d4')

        # attacks opponent piece: d7, a7, g7
        # does not attack friendly piece: d2, b2, f2 ommitted
        expect(queen_moves).to eq(['e4', 'f4', 'g4', 'h4', 'd5', 'd6', 'd7', 'c4', 'b4', 'a4', 'd3', 'e5', 'f6', 'g7', 'e3', 'c3', 'c5', 'b6', 'a7'])
      end

    end
    context 'player 2' do
      let(:board) { ChessBoard.new }
      subject(:validator) { described_class.new(board) }

      it 'moves in rows and columns, does not go out of bounds, attacks opponent pieces and does not attack friendly pieces' do
        board.move_piece('d8', 'd4')

        queen_moves = validator.estimate_queen_moves('d4')

        # attacks opponent piece: d2, a2, f2
        # does not attack friendly piece:  d7, a7, g7
        expect(queen_moves).to eq(['e4', 'f4', 'g4', 'h4', 'd5', 'd6', 'c4', 'b4', 'a4', 'd3', 'd2', 'e5', 'f6', 'e3', 'f2', 'c3', 'b2', 'c5', 'b6'])
      end
    end
  end

  # test for player 1 and 2
  # test regular moves/does not go out of bounds
  # test attack moves on opponent's pieces
  # test that it cannot attack own pieces
  describe '#estimate_king_moves' do
    context 'player 1' do
      let(:board) { ChessBoard.new }
      subject(:validator) { described_class.new(board) }

      it 'moves in rows and columns, does not go out of bounds' do
        board.move_piece('e1', 'a4')

        king_moves = validator.estimate_king_moves('a4')

        expect(king_moves).to eq(['a5', 'b5', 'b4', 'b3', 'a3'])
      end

      it 'does not attack friendy pieces' do 
        board.move_piece('e1', 'e3')

        king_moves = validator.estimate_king_moves('e3')

        expect(king_moves).to eq(['e4', 'f4', 'f3', 'd3', 'd4'])
      end

      it 'attacks opponent pieces, avoids being attacked' do 
        board.move_piece('e1', 'd4') # king
        board.move_piece('a7', 'd5') # opponent pawn

        king_moves = validator.valid_moves('d4') # finds king moves, but also removes moves that threaten own king

        expect(king_moves).to eq(["e5", "e3", "d3", "c3", "c5", "d5"])
      end

    end
    context 'player 2' do
      let(:board) { ChessBoard.new }
      subject(:validator) { described_class.new(board) }

      it 'moves in rows and columns, does not go out of bounds' do
        board.move_piece('e8', 'a5')

        king_moves = validator.estimate_king_moves('a5')

        expect(king_moves).to eq(["a6", "b6", "b5", "b4", "a4"])
      end

      it 'does not attack friendy pieces' do 
        board.move_piece('e8', 'e6')

        king_moves = validator.estimate_king_moves('e6')

        expect(king_moves).to eq(['f6', 'f5', 'e5', 'd5', 'd6'])
      end

      it 'attacks opponent pieces, avoids being attacked' do 
        board.move_piece('e8', 'd5') # king
        board.move_piece('a2', 'd4') # opponent pawn

        king_moves = validator.valid_moves('d5') # finds king moves, but also removes moves that threaten own king

        expect(king_moves).to eq(["d6", "e6", "e4", "c4", "c6", "d4"])
      end
    end
  end

  # player #2 tests not written since code is player_num agnostic
  describe '#get_threatening_pieces' do 
    context 'player 1' do 
      let(:board) { ChessBoard.new }
      subject(:validator) { described_class.new(board) }

      it 'identifies threatening pieces using the relative_moves of rook, bishop, knight' do 
        board.move_piece('e1', 'd4') # move king
        board.move_piece('d2', 'd3') # move own pawn to block
        board.move_piece('a8', 'c4') # move opponent rook
        board.move_piece('b8', 'b5') # move opponent bishop

        threatening_pieces = validator.get_threatening_pieces('d4')

        expect(threatening_pieces).to eq(['c4', 'b5'])
      end


      it 'Bug checker: When one king could but doesnt attack the other king, an infinite loop isnt triggered' do
        board.move_piece('e2', 'f3') # move pawn out of the way
        board.move_piece('e7', 'f6') # move pawn out of the way

        threatening_pieces_to_king = validator.get_threatening_pieces('e1')

        expect(threatening_pieces_to_king).to eq([])
      end
    end
  end

  # #valid_moves calls #remove_moves_that_jeopardize_king
  # this method is testing both methods
  describe '#valid_moves / #remove_moves_that_jeopardize_king' do 
    context 'player 1' do 
      let(:board) { ChessBoard.new }
      subject(:validator) { described_class.new(board) }

      it 'Rook: remove moves that threaten own king' do 
        board.move_piece('e1', 'e4') # move king
        board.move_piece('a1', 'd4') # move rook
        board.move_piece('a8', 'c4') # move opponent rook to threaten king
        board.move_piece('b8', 'b5') # move opponent knight to threaten king

        valid_rook_moves = validator.valid_moves('d4')

        expect(valid_rook_moves).to eq(['c4'])
      end

      it 'Rook: if no moves jeopardize own king, do not change input array' do 
        board.move_piece('a2', 'e4') # move pawn out of way so rook can move

        valid_rook_moves = validator.valid_moves('a1')

        expect(valid_rook_moves).to eq(['a2', 'a3', 'a4', 'a5', 'a6', 'a7'])
      end

      it 'Bishop: remove moves that threaten own king' do 
        board.move_piece('e1', 'e4') # move king
        board.move_piece('c1', 'd4') # move bishop
        board.move_piece('a8', 'c4') # move opponent rook to threaten king
        board.move_piece('b8', 'b5') # move opponent knight to threaten king

        valid_bishop_moves = validator.valid_moves('d4')

        expect(valid_bishop_moves).to eq([])
      end

      it 'Bishop: if no moves jeopardize own king, do not change input array' do 
        board.move_piece('d2', 'e4') # move pawn out of way so bishop can move

        valid_bishop_moves = validator.valid_moves('c1')

        expect(valid_bishop_moves).to eq(['d2', 'e3', 'f4', 'g5', 'h6'])
      end

      it 'Knight: remove moves that threaten own king' do 
        board.move_piece('e1', 'e4') # move king
        board.move_piece('b1', 'd4') # move knight
        board.move_piece('a8', 'c4') # move opponent rook to threaten king
        board.move_piece('b8', 'b5') # move opponent knight to threaten king

        valid_knight_moves = validator.valid_moves('d4')

        expect(valid_knight_moves).to eq([])
      end

      it 'Knight: if no moves jeopardize own king, do not change input array' do 
        valid_knight_moves = validator.valid_moves('b1')

        expect(valid_knight_moves).to eq(['c3', 'a3'])
      end
    end
  end

  describe '#promotable?' do
    context 'player 1' do 
    let(:board) { ChessBoard.new }
    subject(:validator) { described_class.new(board) }
      it 'returns true when p2 pawn has reached the end of board' do
        board.move_piece('a2', 'a8')
        promotable = validator.promotable?('a8')

        expect(promotable).to be(true)
      end

      it 'returns false when p2 pawn has not reached end' do 
        promotable = validator.promotable?('a2')

        expect(promotable).to be(false)
      end

      it 'returns false when piece is not a pawn' do 
        promotable = validator.promotable?('a1')

        expect(promotable).to be(false)
      end
    end

    context 'player 2' do
    let(:board) { ChessBoard.new }
    subject(:validator) { described_class.new(board) }
      it 'returns true when p2 pawn has reached the end of board' do
        board.move_piece('a7', 'a1')
        promotable = validator.promotable?('a1')

        expect(promotable).to be(true)
      end

      it 'returns false when p2 pawn has not reached end' do 
        promotable = validator.promotable?('a7')

        expect(promotable).to be(false)
      end

      it 'returns false when piece is not a pawn' do 
        promotable = validator.promotable?('a8')

        expect(promotable).to be(false)
      end
    end
  end

end