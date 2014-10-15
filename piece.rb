class Piece
  attr_accessor :position
  attr_reader :board, :color
  
  ORTHOGONAL = [[1, 0], [-1, 0], [0, 1], [0, -1]]
  DIAGONAL = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
  
  def initialize(board, position, color)
    @board = board
    @position = position
    @color = color
  end
  
  def on_board?(position)
    position.all? { |x| (0...8).include?(x) }
  end
  
  def move(new_position)
    if valid_moves.include?(new_position)
      @board[new_position], @board[@position] = self, nil
      @position = new_position
    else
      raise "Invalid Move"
    end
  end
end

