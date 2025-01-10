require_relative "lib/game"

game = Game.new

20.times { game.roll(5) }
