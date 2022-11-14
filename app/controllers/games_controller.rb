require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def word_exists?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    [user["found"], user["word"], user["length"]]
  end

  def game_result(result1, result2, word, grid)
    if result1 == false
      "Sorry but <em>#{word}</em> can't be built out of #{grid}"
    elsif result2 == false
      "Sorry but <em>#{word}</em> does not seem to be a valid english word..."
    elsif result1 && result2 == true
      "<em>Congratulations! #{word.capitalize}</em> is a valid english word!"
    end
  end

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @array = @word.upcase.chars
    @letters = params[:letters].split

    @letters.each do |letter|
      @array.delete_at(@array.index(letter)) if @array.include? letter
    end

    @result = @array[0].nil?
    @result2 = word_exists?(@word)

    @game_result = game_result(@result, @result2[0], @word, @letters)
  end
end
