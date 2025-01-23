FrameScore = Data.define(:frame, :balls_rolled, :cursor) do
  def scoreable?
    !!score
  end

  def score
    return unless frame.completed?

    case
    when frame.strike?
      return unless balls_rolled.length > cursor + 1

      10 + balls_rolled[cursor] + balls_rolled[cursor + 1]
    when frame.spare?
      return unless balls_rolled.length > cursor

      10 + balls_rolled[cursor]
    else
      return frame.ball_scores.sum
    end
  end
end
