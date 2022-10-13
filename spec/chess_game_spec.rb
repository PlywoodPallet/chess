
require_relative '../lib/chess_board'
require_relative '../lib/chess_piece'
require_relative '../lib/chess_game'

describe ChessGame do

  #TODO test all conditions of #verify_start_coord
  #TODO test select_move and choose_move with the check? function. Use the test from #check to recreate check? == true

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

  describe '#checkmate?' do
    subject(:game) { described_class.new }
    it 'returns true when king is under threat and has no legal moves' do 
      board = game.board

      board.move_piece('e1', 'd4')
      board.move_piece('d2', 'd3')
      board.move_piece('a8', 'c4')
      board.move_piece('b8', 'b5')
      board.move_piece('d7', 'd5')
      board.move_piece('d8', 'e4')

      checkmate = game.checkmate?(1)

      expect(checkmate).to eq(true)

    end

    it 'returns false when king is under check' do 
      # use the default state of the board
      board = game.board

      board.move_piece('e1', 'd4') # move king into position
      board.move_piece('d2', 'd3') # block king with own pawn
      board.move_piece('a8', 'c4') # move opponent rook to threaten king
      board.move_piece('b8', 'b5') # move opponent knight to threaten king

      checkmate = game.checkmate?(1)

      expect(checkmate).to eq(false)
    end

    it 'returns false when king is not threatened' do 
      # use the default state of the board
      check = game.checkmate?(1)

      expect(check).to eq(false)
    end
  end
end