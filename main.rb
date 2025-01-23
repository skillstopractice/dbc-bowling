require_relative "lib/game"

game = Game.new

game << 8
game << 2
game << 5
game << 4
game << 9
game << 0
game << 10
game << 10
game << 5
game << 5
game << 5
game << 3
game << 6
game << 3
game << 9
game << 1
game << 9
game << 1
game << 10

# 8 / . 5 4 . 9 - . X - . X - . 5 / . 5 3 . 6 3 . 9 / . 9 / X

p game.frame_scores.map { |e| e.score }
