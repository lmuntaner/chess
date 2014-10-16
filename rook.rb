# encoding: utf-8
require_relative 'sliding'

class Rook < SlidingPiece
  
  def move_dirs
    ORTHOGONAL
  end
  
  def to_s
    @color == :black ? " ♜ " : " ♖ "
  end
end
