# Represents a single cell in the Sudoku puzzle.
# Coordinates are offered by @row and @cell (1-9)
# A cell is considered solved when the @value != 0
class Cell
  attr_reader :row, :column
  attr_accessor :value

  def initialize(row, column)
    @row = row
    @column = column
    @value = 0
  end

  def solved?
    !@value.zero?
  end

  def position
    [@row, @column]
  end
end
