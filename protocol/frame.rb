require_relative "../vendor/contractor"

module Protocol
  module Frame
    unless Contractor.conditions_disabled?
      def initialize(frame_number)
        Contractor.for("A newly created frame")
                  .assumes("has a number between 1..10") { (1..10).include?(frame_number) }
                  .work { super }
      end

      def score
        if scoreable?
          Contractor.for("A scorable frame")
                    .ensures("has a score") { |result| result }
                    .work { super }
        else
          Contractor.for("A non scorable frame")
                    .ensures("has no score") { |result| result.nil? }
                    .work { super }
        end
      end

      def scoreable?
        if all_balls_rolled? && bonus_computable?
          Contractor.for("A scorable frame")
                    .ensures("is one where all balls have been rolled and the bonus is computable") { |result| result }
                    .work { super }
        else
          Contractor.for("An unscorable frame")
                    .ensures("either has not had all balls rolled yet, or its bonus is not yet computable") { |result| ! result }
                    .work { super }
        end
      end

      def <<(roll)
        contractor = Contractor.for("Adding a roll to a frame")

        contractor.assumes("roll is between 0 and 10 pins") { (0..10).include?(roll) }

        if last_frame? && strike_or_spare?
          contractor.acknowledges("Strike or spare on last frame")
          contractor.assumes("At most two balls have been rolled already") { (0..2).include?(balls_rolled) }
          contractor.assumes("sum of all pins knocked down in frame is no more than 20") { (pins_knocked_down + roll) <= 20 }
        else
          contractor.assumes("At most one ball has been rolled already") { (0..1).include?(balls_rolled) }
          contractor.assumes("sum of all pins knocked down in frame is no more than 10") { (pins_knocked_down + roll) <= 10 }
        end

        contractor.work { super }
      end

      def regular_frame?
        if last_frame?
          Contractor.for("The last frame")
                    .ensures("is not a regular frame") { |result| !result }
                    .work { super }
        else
         Contractor.for("A regular frame")
                   .ensures("is any frame other than the last frame") { |result| result }
                   .work { super }
        end
      end

      def last_frame?
        if frame_number == 10
          Contractor.for("The last frame")
                    .ensures("is frame 10") { |result| result }
                    .work { super }
        else
          Contractor.for("Frames before frame 10")
                    .assumes("i.e. frames 1..9") { (1..9).include?(frame_number) }
                    .ensures("are not the last frame") { |result| !result }
                    .work { super }
        end
      end
    end
  end
end
