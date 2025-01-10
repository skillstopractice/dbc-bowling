require_relative "../protocol/game"

class Game
  prepend Protocol::Game

  def score
    0
  end
end
