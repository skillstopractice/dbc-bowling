require_relative "../vendor/contractor"

module Protocol
  module Game
    def initialize
      Contractor.for("A newly created game")
                .ensures("score begins at zero") { |result| score == 0 }
                .work { super }
    end
  end
end
