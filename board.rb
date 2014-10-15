# encoding: utf-8
require_relative 'rook'
require './bishop'
require './queen'
require './knight'
require './king'
require './pawn'
require 'colorize'

class Board
  attr_reader :grid
  
  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end
  
  def [](pos)
    @grid[pos[0]][pos[1]]
  end
  
  def []=(pos, piece)
    @grid[pos[0]][pos[1]] = piece
  end
  
  def deep_dup
    dup_board = Board.new()
    dup_board.grid.each_with_index do |row, index1|
      row.each_with_index do |col, index2|
        if self[[index1, index2]].nil?
          dup_board[[index1, index2]] = nil
        else
          color = self[[index1, index2]].color
          dup_piece = self[[index1, index2]].class.new(dup_board, [index1, index2], color)
          dup_board[[index1, index2]] = dup_piece
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
    place_blacks
    place_whites
    self[[5, 6]] = Pawn.new(self, [5, 6], :black)
  end
  
  def place_blacks
    place_pawns(:black)
    place_rooks(:black)
    place_bishops(:black)
    place_queen(:black)
    place_king(:black)
    place_knights(:black)
  end
  
  def place_whites
    place_pawns(:white)
    place_rooks(:white)
    place_bishops(:white)
    place_queen(:white)
    place_king(:white)
    place_knights(:white)
  end
  
  def place_rooks(color)
    row = init_row(color)
    [0, 7].each { |col| self[[row, col]] = Rook.new(self, [row, col], color) }
  end
  
  def place_bishops(color)
    row = init_row(color)
    [2, 5].each { |col| self[[row, col]] = Bishop.new(self, [row, col], color) }
  end
  
  def place_knights(color)
    row = init_row(color)
    [1, 6].each { |col| self[[row, col]] = Knight.new(self, [row, col], color) }
  end
  
  def place_king(color)
    row = init_row(color)
    self[[row, 4]] = King.new(self, [row, 4], color)
  end
  
  def place_queen(color)
    row = init_row(color)
    self[[row, 3]] = Queen.new(self, [row, 3], color)
  end
  
  def place_pawns(color)
    row = (color == :black ? 1 : 6)
    8.times { |col| self[[row, col]] = Pawn.new(self, [row, col], color) }
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
    # system("clear")
    @grid.each_with_index do |row, index1|
      row_str = []
      row.each_with_index do |el, index2|
        back = (index1 + index2).even? ? :light_white : :white
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