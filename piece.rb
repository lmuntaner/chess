class Piece
  attr_accessor :position
  attr_reader :board, :color
  
  ORTHOGONAL = [[1, 0], [-1, 0], [0, 1], [0, -1]]
  DIAGONAL = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
  
  def initialize(board, position, color)
    @board = board
    @position = position
    @color = color
    @first_move = true
  end
  
  def on_board?(position)
    position.all? { |x| (0...8).include?(x) }
  end
  
  def move(new_position)
    if updated_valid_moves.include?(new_position)
      @board[new_position], @board[@position] = self, nil
      @position = new_position
      @first_move = false
    else
      raise "Invalid Move"
    end
  end
  
  def move!(new_position)
    if valid_moves.include?(new_position)
      @board[new_position], @board[@position] = self, nil
      @position = new_position
    else
      raise "Invalid Move"
    end
  end
  
  def updated_valid_moves
    update_moves = []
    valid_moves.each do |move|
      dup_board = @board.deep_dup
      dup_board.move!(position, move, color)
      update_moves << move unless dup_board.in_check?(color)
    end
    update_moves
  end
  
end

