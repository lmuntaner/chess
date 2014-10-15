require './piece'

class SteppingPiece < Piece
  
  def valid_moves
    moves = []
    move_dirs.each do |unit_move|
      new_position = []
      2.times { |j| new_position[j] = @position[j] + unit_move[j] }
      next unless on_board?(new_position)
      next if @board.occupied?(new_position) && 
              @board[new_position].color == @color
      moves << new_position
    end
    moves
  end
end