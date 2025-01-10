require_relative "../protocol/game"

class Game
  prepend Protocol::Game

  def initialize
    @score            = 0
    @frame_scores     = []
    @current_frame    = 1
    @completed_frames = []
  end

  attr_reader :score, :completed_frames, :current_frame

  def roll(ball_score)
    if frame_ending_roll?(ball_score)
      record_ball_score(ball_score)
      start_new_frame
    else
      record_ball_score(ball_score)
    end
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

  # ...

  def frame_ending_roll?(ball_score)
    not_last_frame_yet? && (strike?(ball_score) || second_ball_in_frame?)
  end

  def strike?(ball_score)
    ball_score == 10
  end

  # ...

  def last_frame?
    current_frame == 10
  end

  def not_last_frame_yet?
    !last_frame?
  end

  # FIXME: Not exactly correct. Only allow third ball if two strikes in last frame.
  def not_yet_completed?
    not_last_frame_yet? || @frame_scores.length < 3
  end

  # ...

  def record_ball_score(score)
    @frame_scores << score
  end

  def start_new_frame
    @completed_frames << @frame_scores

    @frame_scores = []
  end
end
