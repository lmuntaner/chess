# encoding: utf-8
require './sliding'

class Bishop < SlidingPiece
  def move_dirs
    DIAGONAL
  end
  
  def to_s
    @color == :black ? " ♝ " : " ♗ "
  end
end
