# frozen_string_literal: true

# Class Documentation
class GamesController < ApplicationController
  # helper_method :score

  def new
    @letters = []
    10.times { @letters.append(('a'..'z').to_a.sample) }
  end

  def score
    # @score ||= 0
    @word = params[:word]
    @letters = params[:letters]
    @message = "#{@word} is not a combination of #{@letters}" unless word_from_letters?(@word, @letters)

    @message = "#{@word} is not a valid word" if word_from_letters?(@word, @letters) && !a_word?(@word)

    @score = @word.length
    # session[:score] = @score
    if word_from_letters?(@word, @letters) && a_word?(@word)
      if session[:user_score].nil?
        session[:user_score] = @score
      else
        session[:user_score] += @score
      # binding.pry
      @message = "Congratulations, #{@word} is a valid English word!"
      end
    end
  end

  private

  def word_from_letters?(word, letters_array)
    word_array = word.split('')
    word_array.all? do |letter|
      word_array.count(letter) <= letters_array.count(letter)
    end
  end

  def a_word?(word)
    response = RestClient.get("https://wagon-dictionary.herokuapp.com/#{word}")
    repos = JSON.parse(response)
    repos['found']
  end
end
