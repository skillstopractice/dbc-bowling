require_relative "../protocol/game"

class Game
  prepend Protocol::Game

  def initialize
    @score         = 0
    @ball_scores   = []
    @current_frame = 1
  end

  attr_reader :score, :ball_scores, :current_frame

  def roll(ball_score)
    if ball_score == 10
      @current_frame += 1 unless @current_frame == 10
    end

    @ball_scores << ball_score

    @score += ball_score
  end
end
