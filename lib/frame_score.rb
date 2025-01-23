FrameScore = Data.define(:frame, :balls_rolled, :cursor) do
  def scoreable?
    !!score
  end

  def score
    return unless frame.completed?

    case
    when frame.strike?
      return unless bonus_rolls_completed?

      10 + balls_rolled[cursor + 1] + balls_rolled[cursor + 2]
    when frame.spare?
      return unless bonus_rolls_completed?

      10 + balls_rolled[cursor + 2]
    else
      return frame.ball_scores.sum
    end
  end

  def bonus_rolls_completed?
    balls_rolled.length > cursor + 2
  end
end
