# Represents a single cell in the Sudoku puzzle.
# Coordinates are offered by @row and @column (1-9)
# A cell is considered solved when the @solution != 0
# Cells are required to have coordinates.
# Cell solution defaults to 0 and must be set manually for solved cells.
class Cell
  attr_reader :row, :column, :solution
  attr_accessor :possible_solutions, :test_solutions

  def initialize(row, column, solution = 0)
    @row = row
    @column = column
    @solution = solution
    @possible_solutions = []
    @test_solutions = []
  end

  def solve
    if @test_solutions.length == 1
      @solution = @test_solutions.pop
    end
  end

  def solved?
    !@solution.zero?
  end

  def coordinates
    [@row, @column]
  end

  def to_s
    "row: #{@row}, column: #{@column}"
  end
end

# Parent class for groups of cells. Used by Row, Column, and Grid.
# Provides shared methods for checking and validating solutions.
class CellGroup
  attr_reader :cells, :position

  def solved?
    @cells.length == 9 && @cells.all? { |cell| cell.solved? } && valid_solution
  end

  def unsolved
    @cells.select { |cell| !cell.solved? }
  end

  def solutions
    @cells.map { |cell| cell.solution }
  end

  def missing_solutions
    valid_solutions - solutions
  end

  protected
  def valid_solution
    solutions.uniq.sort == valid_solutions
  end

  def valid_solutions
    [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end
end

# Collection of 9 cells that belong in a grid.
# Grids are numbered from top to right, with the top left being 1
# and the bottom right being 9.
class Grid < CellGroup
  def initialize(cells, position)
    @cells = cells
    @position = position
  end
end

# Collection of cells that belong in the same column row.
class Row < CellGroup
  def initialize(cells)
    @cells = cells.sort_by(&:column)
    @position = @cells.first.row
  end
end

# Collection of cells that belong in the same column.
class Column < CellGroup
  def initialize(cells)
    @cells = cells.sort_by(&:row)
    @postion = @cells.first.column
  end
end
