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
  def solve
    unsolved_cells = @cells.select { |cell| !cell.solved? }
    unsolved_cells.each do |cell|
      column = column(cell.column)
      row = row(cell.row)
      grid = grid(cell)

      missing_solutions = {}
      missing_solutions[:column] = column.missing_solutions
      missing_solutions[:row] = row.missing_solutions
      missing_solutions[:grid] = grid.missing_solutions

      solutions = {}
      solutions[:column] = column.solutions
      solutions[:row] = row.solutions
      solutions[:grid] = grid.solutions

      groups = [:column, :row, :grid]
      missing_solutions.each do |key, missing|
        check_list = groups
        check_list.delete(key)
        check_list.each do |group|
          missing.delete_if { |invalid| solutions[group].include?(invalid) }
          cell.possible_solutions << missing
        end
      end

      cell.possible_solutions.flatten!.uniq!.sort!

      # for debugging!
      puts cell.possible_solutions.join(" - ")
      cell.solve

      # for debugging!
      puts "solved a cell!" if cell.solved?
    end
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

    grid_maps.each_with_index { |grid, i| grids << Grid.new(grid, i+1) }
  end
end
