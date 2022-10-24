require_relative 'lib/chess_game'
require_relative 'lib/chess_board'
require_relative 'lib/chess_piece'
require_relative 'lib/move_validator'
require_relative 'lib/string' # console font styles

extend Serializable

# If a saved game is detected, ask the player if they want to restore it
# Otherwise, play a new game
if Dir.exist?('saved_games') && !Dir.empty?('saved_games')
  save_choice = save_game_player_input
  if save_choice.upcase == 'YES' || save_choice.upcase == 'Y'
    load_game.play_game
  else
    game = ChessGame.new
    game.play_game
  end
else
  game = ChessGame.new
  game.play_game
end

def save_game_player_input
  verified_save_choice = ''
  loop do
    puts 'Saved game detected, would you like to restore it? (Yes/No)'
    verified_save_choice = verify_player_input(player_input)

    # break if not nil
    break if verified_save_choice
  end
  verified_save_choice
end

def verify_player_input(raw_input)
  return raw_input if raw_input.upcase == 'YES' || raw_input.upcase == 'NO'
  return 'yes' if raw_input.upcase == 'Y' # add these options for usability
  return 'no' if raw_input.upcase == 'N'
  nil
end

# get player input then convert to string
def player_input
  gets.chomp.to_s
end

# game = ChessGame.new
# board = game.chess_board
# validator = game.move_validator
# board.clear_board('a1')
# p moves = validator.estimate_rook_bishop_queen_moves('a1')
# board.print_board
# game.play_game