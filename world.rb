class World

  SIZE = 44

  def initialize
    @cells = Matrix.build(SIZE, SIZE){ nil }
    @tick  = 0
    @alive = 0
  end

  def add_cell(cell)
    @cells[*cell.position] = cell
  end

  def tick!
    @tick += 1
    @alive = 0

    to_kill = []
    to_live = []

    @cells.each_with_index do |cell, y, x|
      if cell
        if should_die?(cell)
          to_kill << cell
        else
          @alive += 1
        end
      else
        candidate = Cell.new(x,y)
        if should_live?(candidate)
          to_live << candidate
          @alive += 1
        end
      end
    end

    to_kill.each{ |cell| kill_cell(cell) }
    to_live.each{ |cell| add_cell(cell) }
  end

  def cell_status(x, y)
    get_cell(x,y).nil? ? :dead : :live
  end

  def print
    puts "\e[H\e[2J"
    puts "Year #{@tick} - Alive: #{@alive} - Dead: #{SIZE*SIZE - @alive}"
    puts
    puts '==' * SIZE
    @cells.each_with_index do |cell, y, x|
      putc cell_status(x,y) == :live ? '*' : ' '
      putc ' '
      puts if x == SIZE - 1
    end
    puts '==' * SIZE
    puts

    sleep 0.3
  end

  private

  def should_die?(cell)
    number_of_neighbours = neighbours(cell).length

    number_of_neighbours < 2 || number_of_neighbours > 3
  end

  def should_live?(cell)
    neighbours(cell).length == 3
  end

  def kill_cell(cell)
    @cells[*cell.position] = nil
  end

  def neighbours(cell)
    y, x = cell.position

    xs = [x - 1, x, x + 1].select{|x| x >= 0 && x <= SIZE }
    ys = [y - 1, y, y + 1].select{|y| y >= 0 && y <= SIZE }

    [].tap do |neighbours|
      xs.each do |nx|
        ys.each do |ny|
          next if nx == x && ny == y

          neighbours << get_cell(nx, ny)
        end
      end
    end.compact
  end

  def get_cell(x, y)
    @cells[y, x]
  end
end
