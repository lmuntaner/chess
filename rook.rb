# encoding: utf-8
require './sliding'

class Rook < SlidingPiece
  
  def move_dirs
    ORTHOGONAL
  end
  
  def to_s
    @color == :black ? "♜" : "♖"
  end
end
