require_relative "lib/game"

game = Game.new

10.times { game.roll(10) }
