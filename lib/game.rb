require_relative "../protocol/game"

class Game
  prepend Protocol::Game

  def initialize
    @score       = 0
    @ball_scores = []
  end

  attr_reader :score, :ball_scores

  def roll(ball_score)
    @ball_scores << ball_score

    @score += ball_score
  end
end
