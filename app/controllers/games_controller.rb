class GamesController < ApplicationController
  def new
    alphabet_array = ('A'..'Z').to_a
    @letters = []
    10.times { @letters << alphabet_array.sample(1).join }
    return @letters
  end

  def score
  end
end
