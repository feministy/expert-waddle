# No Gemfile here sorry I ain't sorry
# (I have these installed for my Ruby version)
require 'pry'

# all the code for cells and cell groups
require_relative 'cells'

# Create and solve and Sudoku puzzle!
class Sudoku
  attr_reader :cells, :rows, :columns, :grids

  def initialize(cells)
    @cells = cells
    build
  end

  # WIP! get the logic, clean it up :)
  # General approach:
  # - find all possible solutions for cells
  # - check possible solutions to see if they are the only option for the coords
  # - mark cell as solved if so
  # If it is not solved... then...?
  # Need to implement guess and check, or other method?? This is how I solve.
  def solve
    find_possible_solutions
    recursively_test_possible_solutions

    if !solved?
      # check and guess...?
    end
  end

  # TODO: there's a bug where duplicate solutions can be marked as correct
  def recursively_test_possible_solutions
    @new_solve = false

    unsolved_cells = @cells.select { |cell| !cell.solved? }
    unsolved_cells.map { |cell| cell.test_solutions = [] }

    unsolved_cells.each do |cell|
      column = column(cell.column)
      row = row(cell.row)
      grid = grid(cell)

      find_unique(cell, column)
      find_unique(cell, row)
      find_unique(cell, grid)
      cell.solve

      @new_solve = cell.solved?
    end

    # only start the recursive loop if we found a new solution
    recursively_test_possible_solutions unless solved? || @new_solve
  end

  def find_possible_solutions
    unsolved_cells = @cells.select { |cell| !cell.solved? }
    unsolved_cells.each do |cell|
      column = column(cell.column)
      row = row(cell.row)
      grid = grid(cell)

      missing = (column.missing_solutions + row.missing_solutions + grid.missing_solutions).uniq!
      solutions = (column.solutions + row.solutions + grid.solutions).uniq!

      cell.possible_solutions = missing - solutions
      cell.solve

      # for debugging!
      puts "solved a cell!" if cell.solved?
    end
  end

  def find_unique(cell, group)
    group.unsolved.each do |group_cell|
      unique = cell.possible_solutions - group_cell.possible_solutions
      cell.test_solutions += unique if unique.length == 1
    end
    cell.test_solutions.uniq!
  end

  def solved?
    @cells.length == 81 && @cells.all? { |cell| cell.solved? }
  end

  def row(number)
    @rows[number-=1]
  end

  def column(number)
    @columns[number-=1]
  end

  def grid(cell)
    @grids.select { |grid| grid.cells.include?(cell) }.first
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
    @grids = []
    row_starts = [1, 4, 7]
    grid_maps = []

    # After spending too many hours of my life on this,
    # I am pretty pleased that I came up with a solution... even though it's
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

    grid_maps.each_with_index { |grid, i| grids << Grid.new(grid, i+1) }
  end
end
