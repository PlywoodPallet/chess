#test all conditions of #verify_start_coord

require_relative '../lib/chess_board'
require_relative '../lib/chess_piece'
require_relative '../lib/chess_game'

describe ChessGame do

  describe '#check?' do
    subject(:game) { described_class.new }
    it 'returns true when king is threatened' do 
      board = game.board

      board.move_piece('e1', 'd4') # move king into position
      board.move_piece('d2', 'd3') # block king with own pawn
      board.move_piece('a8', 'c4') # move opponent rook to threaten king
      board.move_piece('b8', 'b5') # move opponent knight to threaten king

      check = game.check?(1)

      expect(check).to eq(true)
    end

    it 'returns false when king is safe' do 
      # use the default state of the board
      check = game.check?(1)

      expect(check).to eq(false)
    end
  end


end