require_relative "frame"
require_relative "frame_score"

class Game
  State = Struct.new(:balls_rolled, :frame_scores, :current_frame)

  def initialize
    @state = State.new(balls_rolled: [],
                       frame_scores: [],
                       current_frame: Frame.new(number: 1))

    @history = []
  end

  def undo
    @state = @history.pop
  end

  def <<(ball_score)
    @history << @state.dup

    @state.balls_rolled  << ball_score
    @state.current_frame << ball_score

    if @state.current_frame.completed?
      @state.frame_scores << FrameScore.new(frame: @state.current_frame,
                                            cursor: @state.balls_rolled.length - @state.current_frame.ball_scores.length,
                                            balls_rolled: @state.balls_rolled)

      unless @state.current_frame.last_frame?
        @state.current_frame = Frame.new(number: @state.current_frame.number + 1)
      end
    end
  end

  def scoreboard
    acc = 0

    @state.frame_scores.select { |e| e.scoreable? }.map { |e| acc += e.score  }
  end
end
