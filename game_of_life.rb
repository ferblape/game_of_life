require 'rubygems'
require 'bundler'

Bundler.require

require 'matrix'
require_relative './matrix_ext'

require_relative './world'
require_relative './cell'

world = World.new

ARGV[0].to_i.times do
  world.add_cell(Cell.new(rand(World::SIZE - 20),rand(World::SIZE - 20)))
end

500.times do 
  world.print
  world.tick!
end
