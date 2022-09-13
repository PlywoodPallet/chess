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




end