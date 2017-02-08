# No Gemfile here sorry I ain't sorry
# (I have these installed for my Ruby version)
require 'pry'
require 'pry-nav'

# Represents a single cell in the Sudoku puzzle.
# Coordinates are offered by @row and @column (1-9)
# A cell is considered solved when the @solution != 0
# Cells are required to have coordinates.
# Cell solution defaults to 0 and must be set manually for solved cells.
class Cell
  attr_reader :row, :column, :solution, :possible_solutions

  def initialize(row, column, solution = 0)
    @row = row
    @column = column
    @solution = solution
    @possible_solutions = []
  end

  def solve
    if @possible_solutions.length == 1
      @solution = @possible_solutions.pop
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
  attr_reader :cells

  def solved?
    @cells.length == 9 && @cells.all? { |cell| cell.solved? } && valid_solution
  end

  def solutions
    @cells.map { |cell| cell.solution }
  end

  protected
  def valid_solution
    solutions.uniq.sort == [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end
end

# Collection of 9 cells that belong in a grid.
# Grids are numbered from top to right, with the top left being 1
# and the bottom right being 9.
class Grid < CellGroup
  attr_reader :position

  def initialize(cells, position)
    @cells = cells
    @position = position
  end
end

# Collection of cells that belong in the same column row.
class Row < CellGroup
  def initialize(cells)
    @cells = cells.sort_by(&:column)
  end
end

# Collection of cells that belong in the same column.
class Column < CellGroup
  def initialize(cells)
    @cells = cells.sort_by(&:row)
  end
end

# Create and solve and Sudoku puzzle!
class Sudoku
  attr_reader :cells, :rows, :columns, :grids

  def initialize(cells)
    @cells = cells
    build
  end

  def solve
    # solve the puzzle!
  end

  def solved?
    @cells.length == 81 && @cells.all? { |cell| cell.solved? }
  end

  def row(number)
    @rows[number+=1]
  end

  def column(number)
    @columns[number+=1]
  end

  protected

  def build
    build_rows
    build_columns
    build_grids
  end

  def build_rows
    @rows = []
    groups = @cells.group_by(&:row)
    groups.each { |row, cells| @rows << Row.new(cells) }
  end

  def build_columns
    @columns = []
    groups = @cells.group_by(&:column)
    groups.each { |row, cells| @columns << Column.new(cells) }
  end

  def build_grids
    row_starts = [1, 4, 7]
    grid_maps = []

    # After spending too many hours of my life on this,
    # I am pretty pleased that I ame up with a solution... even though it's
    # a bit heavy handed. I'll make this better later :)
    row_starts.each do |start|
      starts = [start, start+1, start+2]
      columns = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      columns.each do |col_starts|
        grid_maps << @cells.select do |cell|
          col_starts.include?(cell.column) && starts.include?(cell.row)
        end
      end
    end

    @grids = grid_maps.each_with_index { |grid, index| Grid.new(grid, index+1) }
  end
end
