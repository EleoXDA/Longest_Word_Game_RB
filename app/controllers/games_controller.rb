class GamesController < ApplicationController
  def new
    @letters = Array.new(5) { %w[A E I O U Y].sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - %w[A E I O U Y]).sample }
  end

  def score
    raise
  end
end
