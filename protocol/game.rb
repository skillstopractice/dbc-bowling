require_relative "../vendor/contractor"

module Protocol
  module Game
    def initialize
      Contractor.for("A newly created game")
                .ensures("score begins at zero") { |result| score == 0 }
                .work { super }
    end

    def roll(ball_score)
      contractor = Contractor.for("Recording a player's roll")

      contractor.assumes("a single ball will knock down between 0 and 10 pins") do
        (0..10).include?(ball_score)
      end

      contractor.assumes("At most 20 balls have already been rolled before this one") do
        ball_scores.length <= 20
      end

      contractor.alters(:score) { score }

      contractor.ensures("game score will increase by at least the ball score amount") do |result, diff|
        diff[:score][:after] >= diff[:score][:before] + ball_score
      end

      contractor.work { super }
    end
  end
end
