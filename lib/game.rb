require_relative "../protocol/game"

class Game
  prepend Protocol::Game

  def roll(ball_score)

  end

  def score
    0
  end
end
