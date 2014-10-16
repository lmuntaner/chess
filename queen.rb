# encoding: utf-8
require_relative 'sliding'

class Queen < SlidingPiece
  
  def move_dirs
    DIAGONAL + ORTHOGONAL
  end
  
  def to_s
    @color == :black ? " ♛ " : " ♕ "
  end
end
