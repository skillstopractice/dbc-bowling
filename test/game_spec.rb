require "minitest/autorun"
require_relative "../lib/game"

describe "Game#roll" do
  let(:game) { Game.new }
  let(:invalid_rolls) { [-1,-42,nil,:eggs] }

  it "should not allow values other than 1..10 for a ball score" do
    invalid_rolls.each do |ball_score|
      assert_raises { game.roll(ball_score) }
    end
  end

  it "should allow 1..10 for a ball score" do
    skip

    #(1..10).each { |ball_score| game.roll(ball_score) }
  end

  it "should allow up to 21 balls to be rolled" do
    skip

    #21.times { |ball_score| game.roll(10) } # the perfect game, glorious
  end

  it "should not allow more than 21 balls to be rolled" do
    skip
    #assert_raises { 22.times { |ball_score| game.roll(10) } }
  end
end
