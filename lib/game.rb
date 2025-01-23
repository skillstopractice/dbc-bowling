require_relative "frame"
require_relative "frame_score"

class Game
  def initialize
    @balls_rolled     = []
    @frame_scores     = []
    @current_frame    = Frame.new(number: 1)
  end

  def <<(ball_score)
    @balls_rolled  << ball_score
    @current_frame << ball_score

    if @current_frame.completed?
      @frame_scores << FrameScore.new(frame: @current_frame,
                                      cursor: @balls_rolled.length - @current_frame.ball_scores.length,
                                      balls_rolled: @balls_rolled)

      unless @current_frame.last_frame?
        @current_frame = Frame.new(number: @current_frame.number + 1)
      end
    end
  end

  def scoreboard
    acc = 0

    @frame_scores.select { |e| e.scoreable? }.map { |e| acc += e.score  }
  end
end
