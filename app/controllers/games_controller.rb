require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { ('a'..'z').to_a[rand(26)] }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @result = if exist?(@word) && include?(@word, @letters)
                "Congratulations ! #{@word} is a valid English word !"
              elsif !include?(@word, @letters)
                "Sorry but #{@word} can't be built out of #{@letters}"
              elsif !exist?(@word)
                "Sorry but #{@word} doesn't seem to be an english valid word..."
              end
  end

  private

  def exist?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_exist = JSON.parse(URI.open(url).read)
    word_exist[:found.to_s]
  end

  def include?(word, letters)
    letters = letters.split(' ').join
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end
end
