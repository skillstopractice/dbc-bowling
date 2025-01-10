require_relative "../vendor/contractor"

module Protocol
  module Game
    def initialize
      Contractor.for("A newly created game")
                .ensures("begins with a score of zero")      { score == 0 }
                .ensures("begins on the first frame")        { current_frame == 1 }
                .ensures("begins with no balls rolled yet ") { balls_rolled == 0 }
                .work { super }
    end

    def roll(ball_score)
      contractor = Contractor.for("Recording a player's roll")

      contractor.assumes("a single ball will knock down between 0 and 10 pins") do
        (0..10).include?(ball_score)
      end

      contractor.assumes("At most 20 balls have already been rolled before this one") do
        balls_rolled <= 20
      end

      case ball_score
      when 0..9
        contractor.alters(:frame) { current_frame }

        if second_ball_for_frame?
          if current_frame < 10
            contractor.ensures("game advances to next frame on strike in frames 1-9") do |result, diff|
              diff[:frame][:after] == diff[:frame][:before] + 1
            end
          else
            contractor.ensures("game does not change frame in frame 10") do |result, diff|
              diff[:frame][:after] == diff[:frame][:before]
            end
          end
        end
      when 10
        contractor.alters(:frame) { current_frame }

        if current_frame < 10
          contractor.ensures("game advances to next frame on strike in frames 1-9") do |result, diff|
            diff[:frame][:after] == diff[:frame][:before] + 1
          end
        else
          contractor.ensures("game does not change frame on strike in frame 10") do |result, diff|
            diff[:frame][:after] == diff[:frame][:before]
          end
        end
      end

      contractor.work { super }
    end
  end
end
