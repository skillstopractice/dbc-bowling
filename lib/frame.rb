require_relative "../protocol/frame"

class Frame
  prepend Protocol::Frame

  def initialize(frame_number)
    @frame_scores = []
  end

  def scoreable?
  end

  def all_balls_rolled?
  end

  def bonus_computable?
  end

  def <<(score)
    @frame_scores << score
  end

  attr_reader :score
end
