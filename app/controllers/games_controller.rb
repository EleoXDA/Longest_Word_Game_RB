require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(5) { %w[A E I O U Y].sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - %w[A E I O U Y]).sample }
    @score = session[:score]
  end

  def store_score(score)
    session[:score].nil? ? session[:score] = 0 : session[:score] += score
  end

  def remove_score
    session.delete(:score)
  end

  def score
    letters = params[:letters]
    answer = params[:answer].split('')
    check_array = []
    score = 0

    answer.each do |a|
      if letters.include?(a)
        check_array.push(a)
      end
    end

    url = "https://wagon-dictionary.herokuapp.com/#{answer.join}"
    @url2 = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    parse = JSON.parse(URI.open(url).read)
    check = parse['found']

    if check_array.sort == answer.sort && check == true
      @output = 'Congratulations! You win'
      score = answer.length
    elsif @url2[:found] == true && check == true
      @output = 'Valid Word, but not correct one'
    elsif check == false
      @output = 'WORD is not in the dictionary'
    end

    store_score(score)
  end
end
