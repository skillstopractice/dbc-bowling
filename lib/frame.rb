require_relative "../protocol/frame"

class Frame
  prepend Protocol::Frame

  def initialize(number:)
    @number      = number
    @ball_scores = []
  end

  attr_reader :number, :ball_scores

  def <<(score)
    ball_scores << score
  end

  def beginning_of_frame?
    ball_scores.empty?
  end

  def strike?
    ball_scores.first == 10
  end

  def spare?
    return false if strike?
    return false if second_ball_not_yet_rolled?

    (ball_scores[0] + ball_scores[1]) == 10
  end

  def second_ball_not_yet_rolled?
    ball_scores[1].nil?
  end

  def in_play?
    !completed?
  end

  def completed?
    case number
    when 1..9
      strike? || ball_scores.length == 2
    when 10
      return false if ball_scores[1].nil?

      ((ball_scores[0] + ball_scores[1]) < 10) || (!!ball_scores[2])
    end
  end

  def last_frame?
    number == 10
  end
end
