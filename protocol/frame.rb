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

        contractor.assumes("roll is between 1 and 10 pins") { (1..10).include?(roll) }
                  .work { super }
      end
    end
  end
end
