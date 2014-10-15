# encoding: utf-8
require './stepping'

class Knight < SteppingPiece
  KNIGHT_MOVES = [[1, 2], [2, 1], [-1, 2], [2, -1],
                  [-2, 1], [-2, -1], [1, -2], [-1, -2]]
  
  def move_dirs
    KNIGHT_MOVES
  end
  
  def to_s
    @color == :black ? " ♞ " : " ♘ "
  end
end
