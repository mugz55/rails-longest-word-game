require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet_array = ('A'..'Z').to_a
    @letters = []
    10.times { @letters << alphabet_array.sample(1).join }
    @letters
  end

  def score
    if check_letters(params[:guess], params[:letters]) == false
      @result = "Sorry but #{params[:guess].upcase} can't be built out of #{params[:letters]}..."
    elsif check_dictionary(params[:guess]) == false
      @result = "Sorry, but #{params[:guess].upcase} does not seem to be a valid English word..."
    else
      @result = "Congratulations! #{params[:guess].upcase} is a valid English word!"
      @game_score = calculate_score(params[:guess])
      @total_score = update_score(@game_score)
    end
    @session = session[:games]
  end

  private

  def check_letters(guess, letters)
    guess_array = guess.upcase.chars
    letters_array = letters.split(' ')
    clone = letters_array.clone
    guess_array.each do |letter|
      index = clone.index(letter)
      if index.nil?
        clone
      else
        clone.delete_at(index)
      end
    end
    clone.length == (letters_array.length - guess.length)
  end

  def check_dictionary(guess)
    url = "https://wagon-dictionary.herokuapp.com/#{guess}"
    word = URI.open(url).read
    result = JSON.parse(word)
    result['found']
  end

  def calculate_score(guess)
    guess.length
  end

  def update_score(game_score)
    session[:games] += game_score
    session[:games]
  end
end
