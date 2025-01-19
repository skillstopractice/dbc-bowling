require "minitest/autorun"
require_relative "../lib/game"

describe "Game#roll" do
  # let(:game) { Game.new }
  # let(:invalid_rolls) { [-1,-42,nil,:eggs] }

  # it "should not allow values other than 1..10 for a ball score" do
  #   invalid_rolls.each do |ball_score|
  #     assert_raises { game.roll(ball_score) }
  #   end
  # end

  # it "should allow 1..10 for a ball score" do
  #   (1..10).each { |ball_score| game.roll(ball_score) }
  # end

  # it "should allow 20 balls to be rolled in a game without strikes" do
  #   20.times { |ball_score| game.roll(5) } # the perfect game, glorious
  # end

  # TODO game without strikes
  # game of all strikes
  # game with strikes just in the last frame (still need third ball)
  # game with spare in last frame (still need third ball)
end
