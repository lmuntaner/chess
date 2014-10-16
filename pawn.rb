# encoding: utf-8
require_relative 'piece'

class Pawn < Piece
  attr_reader :first_move
  
  def initialize(board, position, color)
    super(board, position, color)
  end
  
  def move_dirs
    moves = []
    unit_move = (@color == :black ? [1, 0] : [-1, 0])
    moves << (unit_move.map { |v| v * 2 }) if @first_move
    moves << unit_move
  end
  
  def valid_moves
    moves = []
    move_dirs.each do |unit|
      new_position = []
      2.times { |j| new_position[j] = @position[j] + unit[j] }
      if on_board?(new_position) && !@board.occupied?(new_position)
        moves << new_position
      end
      moves += check_diagonals(get_diagonals(new_position)) if unit.first.abs == 1
    end
    moves
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
    sides.select { |side| @board.occupied?(side) && opponent?(side) }
  end
  
  def to_s
    @color == :black ? " ♟ " : " ♙ "
  end
end