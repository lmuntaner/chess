# encoding: utf-8
require './piece'

class Pawn < Piece
  
  def initialize(board, position, color)
    super(board, position, color)
    @move = (@color == :black ? [1, 0] : [-1, 0])
  end
  
  def valid_moves
    moves = []
    new_position = []
    2.times { |j| new_position[j] = @position[j] + @move[j] }
    if on_board?(new_position) && !@board.occupied?(new_position)
      moves << new_position
    end
    side_moves = check_diagonals(get_diagonals(new_position))
    
    moves += side_moves
  end
  
  def get_diagonals(position)
    sides = []
    [1, -1].each do |side|
      new_position = [position[0], position[1] + side]
      sides << new_position if on_board?(new_position)
    end
    
    sides
  end
  
  def check_diagonals(sides)
    diagonals = []
    sides.each do |side|
      next unless @board.occupied?(side)
      diagonals << side if @board[side].color != @color
    end
    diagonals
  end
  
  def to_s
    @color == :black ? "♟" : "♙"
  end
end