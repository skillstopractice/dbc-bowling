require_relative "../vendor/contractor"

module Protocol
  module Frame
    unless Contractor.conditions_disabled?
      def initialize(frame_number)
        Contractor.for("A newly created frame")
                  .assumes("has a number between 1..10") { (1..10).include?(frame_number) }
                  .work { super }
      end

      # FIXME: Does not handle last frame correctly
      def bonus
        if bonus_computable?
          if strike?
            Contractor.for("A frame with a strike")
                      .ensures("gets bonus points equal to the sum of the next two balls rolled") { it == bonus_rolls_after_strike.sum }
                      .work { super }
          elsif spare?
            Contractor.for("A frame with a spare")
                      .ensures("gets bonus points equal to the sum of the next ball rolled") { it == bonus_roll_after_strike }
                      .work { super }
          else
            Contractor.for("A frame with less than 10 pins knocked down")
                      .ensures("gets zero bonus points") { it == 0 }
                      .work { super }
          end
        else
          Contractor.for("Frame bonus")
                    .ensures("won't have a value before it is computable") { it.nil? }
                    .work { super }
        end
      end

      def score
        if scoreable?
          if regular_frame?
            Contractor.for("A scorable regular frame")
                      .ensures("has a score equal to the pins knocked down + bonus") { it == pins_knocked_down + bonus }
                      .work { super }
          else
            Contractor.for("A scorable final frame")
                      .ensures("has a score equal to the pins knocked down") { it == pins_knocked_down }
                      .work { super }
          end
        else
          Contractor.for("A non scorable frame")
                    .ensures("has no score") { it.nil? }
                    .work { super }
        end
      end

      # Try partial specification
      def spare?
        if balls_rolled >= 2 && regular_frame?
          Contractor.for("A spare")
                    .assumes("first roll was less than 10") { frame_scores.first < 10 }
                    .work { super }
        else
          Contractor.for("A non-spare").work { super }
        end
      end

      def scoreable?
        if all_balls_rolled? && bonus_computable?
          Contractor.for("A scorable frame")
                    .ensures("is one where all balls have been rolled and the bonus is computable") { |result| result == true }
                    .work { super }
        else
          Contractor.for("An unscorable frame")
                    .ensures("either has not had all balls rolled yet, or its bonus is not yet computable") { |result| result == false }
                    .work { super }
        end
      end

      def <<(roll)
        contractor = Contractor.for("Adding a roll to a frame")

        contractor.assumes("roll is between 0 and 10 pins") { (0..10).include?(roll) }

        if last_frame? && strike_or_spare?
          contractor.acknowledges("Strike or spare on last frame")
          contractor.assumes("At most two balls have been rolled already") { (0..2).include?(balls_rolled) }

          if spare?
            contractor.assumes("sum of all pins knocked down in frame is no more than 20") { (pins_knocked_down + roll) <= 20 }
          elsif strike?
            contractor.assumes("sum of all pins knocked down in frame is no more than 30") { (pins_knocked_down + roll) <= 30 }
          end
        else
          contractor.assumes("At most one ball has been rolled already") { (0..1).include?(balls_rolled) }
          contractor.assumes("sum of all pins knocked down in frame is no more than 10") { (pins_knocked_down + roll) <= 10 }
        end

        contractor.work { super }
      end

      def regular_frame?
        if last_frame?
          Contractor.for("The last frame")
                    .ensures("is not a regular frame") { it == false }
                    .work { super }
        else
         Contractor.for("A regular frame")
                   .ensures("is any frame other than the last frame") { it == true }
                   .work { super }
        end
      end

      def last_frame?
        if frame_number == 10
          Contractor.for("The last frame")
                    .ensures("is frame 10") { it == true }
                    .work { super }
        else
          Contractor.for("Frames before frame 10")
                    .assumes("i.e. frames 1..9") { (1..9).include?(frame_number) }
                    .ensures("are not the last frame") { it == false }
                    .work { super }
        end
      end

      def next_frame=(frame)
        case
        when regular_frame? && all_balls_rolled?
          Contractor.for("After all balls are rolled in a frame")
                    .assumes("The next frame will have a number one higher than the current frame") { frame.frame_number == frame_number + 1 }
                    .work { super }
        else
          COntractor.broken("A new frame was added incorrectly")
        end
      end

      def next_frame
        case
        when regular_frame? && all_balls_rolled?
        # FIXME can also specify the frame number is one higher than current frame
          Contractor.for("After all balls are rolled in a frame")
                    .ensures("The next frame will have a number one higher than the current frame") { it.frame_number == frame_number + 1 }
                    .work { super }
        when last_frame? && all_balls_rolled?
          Contractor.for("After the last frame is completed")
                    .ensures("there is no next frame") { !it }
                    .work { super }
        end
      end
    end
  end
end
