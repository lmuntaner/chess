# encoding: utf-8
require './stepping'

class King < SteppingPiece
  
  def move_dirs
    DIAGONAL + ORTHOGONAL
  end
  
  def to_s
    @color == :black ? "♚" : "♔"
  end
end
