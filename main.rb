require_relative "lib/game"

game = Game.new

13.times { game.roll(10) }

p game.completed?
