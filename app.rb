# Represents a single cell in the Sudoku puzzle.
# Coordinates are offered by @row and @cell (1-9)
# A cell is considered solved when the @value != 0
# Cells are required to have coordinates.
# Cell value defaults to 0 and must be set manually for solved cells.
class Cell
  attr_reader :row, :column, :value, :possible_solutions

  def initialize(row, column, value = 0)
    @row = row
    @column = column
    @value = value
    @possible_solutions = []
  end

  def solve
    if @possible_solutions.length == 1
      @value = @possible_solutions.pop
    end
  end

  def solved?
    !@value.zero?
  end

  def coordinates
    [@row, @column]
  end
end

class LinearGroup
  attr_reader :cells

  def solved?
    @cells.length == 9 && @cells.all? { |cell| cell.solved?  }
  end
end

class Row < LinearGroup
  def initialize(cells)
    @cells = cells.sort_by(&:column)
  end
end

class Column < LinearGroup
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
    @rows[number++]
  end

  def column(number)
    @columns[number++]
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

  # Grids are ordered left to right, top to bottom, 1-9.
  # The top left grid is one, the bottom right grid is 9.
  def build_grids
    # [c,r]
    # [1,1][2,1][3,1] [1,2][2,2][3,2] [1,3][2,3][3,3]

    # [c,r]
    # [4,1][5,1][6,1] [4,2][5,2][6,2] [4,3][5,3][6,3]

    # increment cols as you make new grids
    # grids 1-3, rows 1-3
    # grids 4-6, rows 4-6
    # grids 7-9, rows 7-9

    # 1: cols 1-3, rows 1-3
    # 2: cols 4-6, rows 1-3
    # 3: cols 7-9, rows 1-3
    # 4: cols 1-3, rows 4-6
    # 5: cols 4-6, rows 4-6
    # 6: cols 7-9, rows 4-6
    # 7: cols 1-3, rows 7-9
    # 8: cols 4-6, rows 7-9
    # 9: cols 7-9, rows 7-9
  end
end
