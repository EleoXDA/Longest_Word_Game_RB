# frozen_string_literal: true

require 'open-uri'

# .rubocop.yml
class GamesController < ApplicationController
  VOWELS = %w[A E I O U Y].freeze

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def store_score(score)
    session[:score].nil? ? session[:score] = 0 : session[:score] += score
  end

  def remove_score
    session.delete(:score)
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || "").upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
