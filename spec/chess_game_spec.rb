
require_relative '../lib/chess_board'
require_relative '../lib/chess_piece'
require_relative '../lib/chess_game'

describe ChessGame do

  #TODO test all conditions of #verify_start_coord
  #TODO test select_move and choose_move with the check? function. Use the test from #check to recreate check? == true

  describe '#check?' do
    subject(:game) { described_class.new }
    it 'returns true when king is threatened' do 
      board = game.chess_board

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
      board = game.chess_board

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
      board = game.chess_board

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

  describe '#stalemate?' do
    subject(:game) { described_class.new }
    it 'situation 1: returns true when player (p2) has no legal moves' do 
      board = game.chess_board

      board.clear_board(['e8', 'e1', 'd1']) # keep p1 king, queen and p2 king
      board.move_piece('e8','h1') # move p2 king
      board.move_piece('e1','a8') # move p1 king
      board.move_piece('d1','f2') # move p1 queen

      stalemate = game.stalemate?(2) # test for player 2

      expect(stalemate).to eq(true)

    end

    it 'situation 1: returns false when player (p1) has moves' do 
      # use the default state of the board
      board = game.chess_board

      board.move_piece('e1', 'd4') # move king into position
      board.move_piece('d2', 'd3') # block king with own pawn
      board.move_piece('a8', 'c4') # move opponent rook to threaten king
      board.move_piece('b8', 'b5') # move opponent knight to threaten king

      stalemate = game.stalemate?(1) # test for player 1

      expect(stalemate).to eq(false)
    end

    it 'situation 2: returns false on starting player board' do 
      # use the default state of the board
      board = game.chess_board

      stalemate = game.stalemate?(1) # test for player 1

      expect(stalemate).to eq(false)
    end
  end

  # TODO: Use rspec to play the game rather than setting up the board manually
  # TODO: test statlemate
  describe '#game_over? / #print_final_message' do
    subject(:game) { described_class.new }
    xit 'When P1 is checkmated, declare the victory condition and P2 as the winner' do
      board = game.chess_board
      
      # TODO: Use rspec to play the game rather than setting up the board manually

      # Fool's Mate (quick checkmate)
      board.move_piece('f2', 'f3') # p1
      board.move_piece('e7', 'e5') # p2
      board.move_piece('g2', 'g4') # p1
      board.move_piece('d8', 'h4') # p2
      
      # p1 is @active_player by default
      game.play_game

      correct_message = "Checkmate! Player 2 wins"

      # TODO: how to test for output? rspec says .to output() is depreciated
      expect(game.print_final_message).to eq(correct_message)
    end
  end

  
end