require './board'

class Game
  attr_reader :current_turn, :board
  
  def initialize
    @current_turn = :white
    @board = Board.new
  end
  
  def change_turn
    @current_turn = (@current_turn == :white ? :black : :white)
  end
  
  def play
    # board.place_pieces
    board.place_pieces
    until board.check_mate?(current_turn)
      system("clear")
      board.display
      call_turn
      begin
        move = get_move
        @board.move(move[0], move[1], @current_turn)
      rescue RuntimeError => e
        puts e.message
        retry
      end
      change_turn
    end
    system("clear")
    board.display
    puts "Checkmate! #{change_turn.to_s.capitalize} wins!"
  end
  
  def call_turn
    puts "It's the #{@current_turn.to_s} turn"
  end
  
  def get_move
    print "Tell me the start position: "
    start = gets.chomp.split.map(&:to_i)
    print "Tell me the end position: "
    final = gets.chomp.split.map(&:to_i)
    [start, final]
  end
end

# g = Game.new
# g.play