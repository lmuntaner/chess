require_relative 'board'

class Game
  attr_reader :current_turn, :board
  
  def initialize
    @current_turn = :white
    @board = Board.new(self)
    @white_time = 0
    @black_time = 0
    @error_message = ""
  end
  
  def change_turn
    @current_turn = (@current_turn == :white ? :black : :white)
  end
  
  def convert_input(input)
    col_s, row_s = input.split('')
    col = ('a'..'h').to_a.index(col_s.downcase)
    row = (row_s.to_i - 8).abs
    [row, col]
  end
  
  def convert_move(move_s)
    if move_s.first == "save"
      :save
    else
      move_s.map { |move| convert_input(move) }
    end
  end
  
  def self.load_game(filename)
    YAML::load_file("saved/#{filename}")
  end
  
  def new_game
    board.place_pieces
    run
  end
  
  def parse_time(time)
    Time.at(time + (8 * 60 * 60)).strftime("%H:%M:%S")
  end
  
  def display_time
    white_splash = (@current_turn == :white ? " * " : "   ")
    black_splash = (@current_turn == :black ? " * " : "   ")
    puts "#{white_splash}White Player: #{parse_time(@white_time)}"
    puts "#{black_splash}Black Player: #{parse_time(@black_time)}"
    puts "Use 'W-A-S-D' to move + 'O' to select and drop a piece"
    puts "Press 'P' to save game"
    puts "Press 'E' to exit"
  end
  
  def run
    until board.check_mate?(current_turn)
      start_time = Time.new
      begin
        move = []
        until move.count >= 2
          call_turn
          display_time
          display_error
          new_move = board.move_cursor
          move << new_move
          move = move.compact
        end
        board.move(move[0], move[1], @current_turn)
      rescue RuntimeError => e
        @error_message = e.message
        retry
      end
      player_time = Time.new - start_time
      if current_turn == :white
        @white_time += player_time
      else
        @black_time += player_time
      end
      change_turn
    end
    end_game
  end
  
  def end_game
    system("clear")
    board.display
    puts "Checkmate! #{change_turn.to_s.capitalize} wins!"
  end
  
  def save_game
    puts "These are your saved files:"
    system("ls -1 saved/")
    print "Save as (filename): "
    filename = gets.chomp
    File.open("saved/#{filename}", "w") do |f|
      f.puts self.to_yaml
    end
  end
  
  def call_turn
    system("clear")
    board.display
    puts "It's the #{@current_turn.to_s} turn"
  end
  
  def display_error
    puts @error_message unless @error_message.empty?
    @error_message = ""
  end
  
  def get_move
    board.move_cursor
  end
end

if __FILE__ == $PROGRAM_NAME
  print "Would you like to load a game (y/n) "
  if gets.chomp.downcase == 'y'
    puts "These are your saves files:"
    system("ls -1 saved/")
    print "Enter filename: "
    filename = gets.chomp
    old_game = Game.load_game(filename)
    old_game.run
  else
    game = Game.new()
    game.new_game
  end
end
