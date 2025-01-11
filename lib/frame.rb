require_relative "../protocol/frame"

class Frame
  prepend Protocol::Frame

  def initialize(frame_number)
    @frame_number      = frame_number
    @frame_scores      = []
  end

  attr_reader :frame_number, :frame_scores

  def pins_knocked_down
    frame_scores.sum
  end

  def balls_rolled
    frame_scores.count
  end

  def regular_frame?
    ! last_frame?
  end

  def strike_or_spare?
    @frame_scores.first == 10 || @frame_scores.first(2).sum == 10
  end

  def last_frame?
    frame_number == 10
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
