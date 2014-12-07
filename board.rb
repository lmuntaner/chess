# encoding: utf-8
require_relative 'rook'
require_relative 'bishop'
require_relative 'queen'
require_relative 'knight'
require_relative 'king'
require_relative 'pawn'
require 'colorize'
require 'yaml'
require 'io/console'

class Board
  attr_reader :grid
  
  def initialize(game)
    @grid = Array.new(8) { Array.new(8) }
    @pointer_pos = [0, 0]
    @game = game
  end
  
  def [](pos)
    @grid[pos[0]][pos[1]]
  end
  
  def []=(pos, piece)
    @grid[pos[0]][pos[1]] = piece
  end
  
  def move_cursor
    input = STDIN.getch
    
    case input
    when "a"
      @pointer_pos[1] -= 1
      nil
    when "d"
      @pointer_pos[1] += 1
      nil
    when "s"
      @pointer_pos[0] += 1
      nil
    when "w"
      @pointer_pos[0] -= 1
      nil
    when "o"
      pos = @pointer_pos.dup
      pos
    when "l"
      pos = @pointer_pos.dup
      pos
    when "p"
      @game.save_game
    when "e"
      exit
    end
  end
    
  def deep_dup
    dup_board = Board.new(@game)
    dup_board.grid.each_with_index do |row, i1|
      row.each_with_index do |col, i2|
        if self[[i1, i2]].nil?
          dup_board[[i1, i2]] = nil
        else
          color = self[[i1, i2]].color
          dup_piece = self[[i1, i2]].class.new(dup_board, [i1, i2], color)
          dup_board[[i1, i2]] = dup_piece
        end
      end
    end
    dup_board
  end
  
  def place_check
    self[[0, 2]] = Rook.new(self, [0, 2], :white)
    self[[1, 1]] = Rook.new(self, [1, 1], :white)
    self[[5, 4]] = Rook.new(self, [5, 4], :black)
    self[[3, 0]] = King.new(self, [3, 0], :black)
    self[[6, 6]] = King.new(self, [6, 6], :white)
  end
  
  def place_pieces
    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    
    [:black, :white].each do |color|
      row = init_row(color)
      pawn_row = (row == 0 ? 1 : 6)
      pieces.each_with_index do |piece, col|
        self[[row, col]] = piece.new(self, [row, col], color)
        self[[pawn_row, col]] = Pawn.new(self, [pawn_row, col], color)
      end
    end
  end
  
  def init_row(color)
    color == :black ? 0 : 7
  end
      

  def move(start, final, color)
    raise "No pieces in that position" if self[start].nil?
    raise "That is not your color!" if self[start].color != color
    self[start].move(final)
  end
  
  def move!(start, final, color)
    self[start].move!(final)
  end
  
  def in_check?(color)
    king_pos = find_king(color)
    @grid.flatten.each do |square|
      next if square.nil? || square.color == color
      return true if square.valid_moves.include?(king_pos)
    end
      
    false
  end
  
  def check_mate?(color)
    colors(color).all? { |p| p.updated_valid_moves.empty? }
  end
  
  def find_king(color)
    king = colors(color).select { |p| p.is_a?(King) }
    # @grid.flatten.each do |square|
    #   return square.position if square.is_a?(King) && square.color == color
    # end
    return king.first.position unless king.empty?
    raise "No #{color.to_s} king!"
  end
  
  def display
    print "   "
    ('a'..'h').each { |l| print " #{l} "}
    puts
    @grid.each_with_index do |row, index1|
      row_str = [" #{(index1 - 8).abs} "]
      row.each_with_index do |el, index2|
        back = (index1 + index2).even? ? :light_white : :white
        back = :light_blue if @pointer_pos == [index1, index2]
        row_str << (el.nil? ? "   " : el.to_s).colorize(:background => back)
      end
      puts row_str.join("")
    end
    puts
  end
  
  def occupied?(pos)
    !self[pos].nil?
  end
  
  def colors(color)
    @grid.flatten.compact.select { |p| p.color == color}
  end

end