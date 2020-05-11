require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    letter_array = ('A'..'Z').to_a
    vowel_array = %w(A E I O U)
    @game_board = []
    9.times do
      @game_board << letter_array.sample
    end
    1.times do
      @game_board << vowel_array.sample
    end
  end

  def score
    guess = params[:guess]
    game_board = params[:game_board]
    submission = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{guess}").read)
    valid = check_em(guess, game_board)
    if submission['found'] == false
      @response = "I'm sorry, #{guess} is not an english word"
    elsif valid == 'invalid'
      @response = "Invalid letter combination of #{guess} on #{game_board}"
    else
      score = score_it(guess)
      @response = "Congradulations you scored #{score} points for your submission of #{guess} on #{game_board}!"
    end
  end

  def check_em(attempt, grid)
    attempt_hash = Hash.new(0)
    attempt.chars.each { |l| attempt_hash[l.upcase] += 1 }
    grid_hash = Hash.new(0)
    grid.chars.each { |l| grid_hash[l] += 1 }
    attempt_hash.each do |key, _value|
      return 'invalid' if attempt_hash[key] > grid_hash[key]
    end
  end

  def score_it(guess)
    guess.length * 10
  end
end
