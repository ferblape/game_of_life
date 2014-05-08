require 'rubygems'
require 'bundler'

Bundler.require

require 'matrix'
require_relative './matrix_ext'

require_relative './world'
require_relative './cell'

describe 'Game Of Life' do
  let(:world) { World.new }

  context 'Rule #1: Any live cell with fewer than two live neighbours dies, as if caused by under-population' do
    it 'A cell should die if has fewer than two live neighbours' do
      world.add_cell(Cell.new(0,0))
      world.tick!

      world.cell_status(0,0).should == :dead
    end
  end

  context 'Rule #2: Any live cell with two or three live neighbours lives on to the next generation' do
    it 'A cell should live if has more two live neighbours' do
      world.add_cell(Cell.new(0,0))
      world.add_cell(Cell.new(1,0))
      world.add_cell(Cell.new(2,0))

      world.tick!

      world.cell_status(1,0).should == :live
    end

    it 'A cell should live if has three live neighbours' do
      world.add_cell(Cell.new(0,0))
      world.add_cell(Cell.new(1,0))
      world.add_cell(Cell.new(2,0))
      world.add_cell(Cell.new(1,1))

      world.tick!

      world.cell_status(1,1).should == :live
    end
  end

  context 'Rule #3: Any live cell with more than three live neighbours dies, as if by overcrowding' do
    it 'A cell should live if has more than three live neighbours' do
      world.add_cell(Cell.new(0,0))
      world.add_cell(Cell.new(1,0))
      world.add_cell(Cell.new(2,0))
      world.add_cell(Cell.new(0,1))
      world.add_cell(Cell.new(1,1))

      world.tick!

      world.cell_status(1,0).should == :dead
      world.cell_status(1,1).should == :dead
    end
  end

  context 'Rule #4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction' do
    it 'A cell should live if has three neighbours and was dead' do
      world.add_cell(Cell.new(0,0))
      world.add_cell(Cell.new(1,0))
      world.add_cell(Cell.new(0,1))

      world.tick!

      world.cell_status(1,1).should == :live
    end

    it 'A cell shouldn´t live if hasn´t have three neighbours and was dead' do
      world.add_cell(Cell.new(0,0))
      world.add_cell(Cell.new(1,0))

      world.tick!

      world.cell_status(0,1).should == :dead
    end
  end
end
