require_relative "lib/game"

game = Game.new

12.times { game.roll(10) }

p game.completed?
