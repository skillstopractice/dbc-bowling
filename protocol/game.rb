require_relative "../vendor/contractor"

module Protocol
  module Game
    unless Contractor.conditions_disabled?
      def initialize
        Contractor.for("A newly created game")
                  .ensures("begins with a score of zero")      { score == 0 }
                  .ensures("begins on the first frame")        { current_frame == 1 }
                  .work { super }
      end

      def completed?
        case completed_frames.count
        when 0..9
          contractor = Contractor.for("An incomplete game")
                                .ensures("has 0..9 completed frames ") { |result| result == false }
        when 10
          contractor = Contractor.for("A completed game")
                                .ensures("has ten completed frames") { |result| result == true }
        else
          # Fixme: This belongs in a completed_frames contract.
          Contractor.broken("Game has #{completed_frames.count} frames, which is invalid")
        end

        contractor.work { super }
      end

      def roll(ball_score)
        contractor = Contractor.for("Updating the bowling scorecard after a roll")

        contractor.assumes("a single ball will knock down between 0 and 10 pins") do
          (0..10).include?(ball_score)
        end

        contractor.assumes("Game has not yet been completed") do
          not_yet_completed?
        end

        contractor.may_alter(:frame) { current_frame }

        if frame_ending_roll?(ball_score)
          contractor.acknowledges("Frame Change")

          contractor.acknowledges("Strike")               if strike?(ball_score)
          contractor.acknowledges("Second ball in frame") if second_ball_in_frame?

          contractor.ensures("game advances to next frame") do |result, diff|
            diff[:frame][:after] == diff[:frame][:before] + 1
          end
        else
          if first_ball_in_frame?
            contractor.acknowledges("First Ball")

            contractor.ensures("game won't change frames when not a strike") do |result, diff|
              diff[:frame][:after] == diff[:frame][:before]
            end
          else
            contractor.acknowledges("Last Frame")

            contractor.ensures("game does not change frame at all in frame 10") do |result, diff|
              diff[:frame][:after] == diff[:frame][:before]
            end
          end
        end

        contractor.work { super }
      end
    end
  end
end
