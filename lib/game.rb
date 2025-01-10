require_relative "../protocol/game"

class Game
  prepend Protocol::Game

  def initialize
    @score = 0
  end

  attr_reader :score

  def roll(ball_score)
    @score += ball_score
  end
end
