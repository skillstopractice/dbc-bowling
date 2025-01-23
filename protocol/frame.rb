require_relative "../vendor/contractor"

module Protocol
  module Frame
    def initialize(number:)
      x = X["A newly created frame"]

      x.assumes("is labeled with a number between 1 and 10") { (1..10).include?(number) }

      case number
      when (1..9)
        x.acknowledges("Ordinary Frame")
         .ensures("Frame #{number} is not the last frame") { ! last_frame? }
      when 10
        x.acknowledges("Final Frame")
         .ensures("Frame 10 is the last frame") { last_frame? }
      end

      x.work { super }
    end

    def <<(ball_score)
      x = X["Adding a ball score to a frame"]

      x.assumes("frame has not yet been completed") { in_play? }

      (1..9).include?(number) ? __follows_rules_for_scoring_an_ordinary_frame_ball(x, ball_score) :
                                __follows_rules_for_scoring_a_final_frame_ball(x, ball_score)

      x.work { super }
    end

    def __follows_rules_for_scoring_an_ordinary_frame_ball(x, ball_score)
      x.acknowledges("Ordinary Frame")

      if beginning_of_frame?
        case ball_score
        when 1..9
          x.ensures("A first ball score of #{ball_score} on frame #{number} does not end the frame") do
            in_play?
          end
        when 10
          x.ensures("A strike at the start of frame #{number} ends the frame") do
            completed?
          end
        end
      else
        x.ensures("The sum of the two rolled balls will be between 0 and 10") do
          (0..10).include?(ball_scores.sum)
        end

        x.ensures("A second rolled ball on frame #{number} always ends the frame") do
          completed?
        end
      end
    end

    def __follows_rules_for_scoring_a_final_frame_ball(x, ball_score)
      x.acknowledges("Final Frame")

      case
      when beginning_of_frame?
        x.ensures("Frame 10 never ends on the first ball") do
          in_play?
        end
      when second_ball_not_yet_rolled?
        x.ensures("Frame 10 ends after the second ball unless there was a strike or spare") do
          ball_scores.sum < 10 ? completed? : in_play?
        end

        if strike?
          x.assumes("The second ball score will be between 0 and 10") { (0..10).include?(ball_score) }
        else
          x.ensures("The sum of first two rolled balls will be between 0 and 10") do
            (0..10).include?(ball_scores.sum)
          end
        end
      else
        x.ensures("Frame 10 ends after the bonus roll for a strike or spare") do
          completed?
        end
      end
    end
  end
end
