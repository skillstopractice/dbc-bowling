require_relative "../protocol/game"

class Game
  prepend Protocol::Game

  def score
  end
end
