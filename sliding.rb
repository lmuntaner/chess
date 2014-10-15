require './piece'

class SlidingPiece < Piece
  
  def sliding_moves(unit_move)
    moves = []
    (1..8).each do |i|
      new_position = []
      2.times { |j| new_position[j] = @position[j] + (unit_move[j] * i) }
      break unless on_board?(new_position)
      if @board.occupied?(new_position)
        moves << new_position unless @board[new_position].color == @color
        break
      else
        moves << new_position
      end
    end
    moves
  end
  
  def valid_moves
    moves = []
    move_dirs.each do |unit_move|
      moves += sliding_moves(unit_move)
    end
    moves
  end
end