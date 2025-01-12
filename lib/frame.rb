require_relative "../protocol/frame"

class Frame
  prepend Protocol::Frame

  def initialize(frame_number)
    @frame_number      = frame_number
    @frame_scores      = []
    @next_frame        = nil
  end

  attr_reader :frame_number, :frame_scores
  attr_accessor :next_frame

  def pins_knocked_down
    frame_scores.sum
  end

  def balls_rolled
    frame_scores.count
  end

  # FIXME: Broken for last frame
  def bonus
    return nil unless bonus_computable?
    return 0   unless strike_or_spare?

    return bonus_rolls_after_strike.sum   if strike?
    return next_frame.frame_scores.first   if spare?
  end

  def regular_frame?
    ! last_frame?
  end

  def strike?
    frame_scores.first == 10
  end

  def spare?
    return false if strike?
    return false if last_frame? && frame_scores[1] == 10

    frame_scores.first(2).sum == 10
  end

  def strike_or_spare?
    strike? || spare?
  end

  def last_frame?
    frame_number == 10
  end

  def score
    return nil unless scoreable?

    last_frame? ? pins_knocked_down : pins_knocked_down + bonus
  end

  def scoreable?
    all_balls_rolled? && bonus_computable?
  end

  def all_balls_rolled?
    if regular_frame?
      strike? || balls_rolled == 2
    else
      (strike_or_spare? && balls_rolled == 3) || balls_rolled == 2
    end
  end

  def bonus_computable?
    if (pins_knocked_down < 10 || last_frame?)
      all_balls_rolled?
    else
      (strike? && next_frame.balls_rolled >= 2) ||
      (strike? && next_frame&.strike? && next_frame&.next_frame&.balls_rolled >= 1) ||
      (spare?  && next_frame.balls_rolled >= 1)
    end
  end

  def bonus_rolls_after_strike
    if last_frame?
      frame_scores.last(2)
    elsif frame_number == 9
      next_frame.frame_scores.first(2)
    else
      if next_frame&.strike?
        frame_after_next = next_frame.next_frame

        [next_frame.frame_scores.first, frame_after_next.frame_scores.first]
      end
    end
  end

  def bonus_roll_after_spare
    last_frame? ? frame_scores.last : next_frame.frame_scores.first
  end

  def <<(score)
    @frame_scores << score
  end
end
