require_relative "../protocol/game"

class Game
  prepend Protocol::Game

  def initialize
    @score         = 0
    @balls_rolled  = 0
    @frame_scores  = []
    @current_frame = 1
  end

  attr_reader :score, :current_frame, :balls_rolled

  def roll(ball_score)
    if ball_score == 10
      @current_frame += 1 unless @current_frame == 10
    end

    # FIXME: THis is actually *wrong* code because it should
    # track scores for prior frames as well.
    if @frame_scores.empty?
      @frame_scores << ball_score
    else
      @frame_scores = []
      @current_frame += 1 unless @current_frame == 10
    end

    @score += ball_score
  end

  def second_ball_for_frame?
    @frame_scores.length == 1
  end
end
