require_relative "../protocol/game"

class Game
  prepend Protocol::Game

  def initialize
    @score            = 0
    @frame_scores     = []
    @completed_frames = []
  end

  attr_reader :score, :completed_frames, :frame_scores

  def roll(ball_score)
    if frame_ending_roll?(ball_score)
      record_ball_score(ball_score)

      if not_last_frame_yet?
        start_new_frame
      else
        finish_game
      end
    else
      record_ball_score(ball_score)
    end
  end

  def completed?
    @completed_frames.count == 10
  end

  private

  def current_frame
    completed_frames.length + 1
  end

  def first_ball_in_frame?
    @frame_scores.empty?
  end

  def second_ball_in_frame?
    @frame_scores.length == 1
  end

  def third_ball_in_frame?
    @frame_scores.length == 2
  end

  # ...

  def pins_left_standing?(ball_score)
    (strike?(ball_score)|| spare?(ball_score)) ? false : true
  end

  def strike?(ball_score)
    ball_score == 10
  end

  def spare?(ball_score)
    second_ball_in_frame? && (frame_scores.last + ball_score) == 10
  end

  def frame_ending_roll?(ball_score)
    if not_last_frame_yet?
      strike?(ball_score) || second_ball_in_frame?
    else
      (second_ball_in_frame? && pins_left_standing?(ball_score)) || third_ball_in_frame?
    end
  end

  # ...

  def last_frame?
    current_frame == 10
  end

  def not_last_frame_yet?
    !last_frame?
  end

  # ...

  def not_yet_completed?
    ! completed?
  end

  # ...

  def record_ball_score(score)
    @frame_scores << score
  end

  def start_new_frame
    @completed_frames << @frame_scores

    @frame_scores = []
  end

  def finish_game
    @completed_frames << @frame_scores
  end
end
