require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters].split
    @word = params[:word].upcase
    if eng_word?(@word)
      if word_grid?(@word, @letters)
        @message_prefix = 'Congratulations! '
        @message_sufix = 'is a valid English word!'
      else
        @message_prefix = 'Sorry, but '
        @message_sufix = " can't be built out of #{@letters.join(', ')}."
      end
    else
      @message_prefix = 'Sorry, but '
      @message_sufix = ' does not seem to be a valid English word.'
    end
  end

  def eng_word?(attempt)
    JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt.downcase}").read)['found']
  end

  def hash_count_letters(letter_array)
    hash_letters = Hash.new(0)
    letter_array.each { |letter| hash_letters[letter.upcase] += 1 }
    hash_letters
  end

  def word_grid?(attempt, grid)
    attempt_hash = hash_count_letters(attempt.split(''))
    grid_hash = hash_count_letters(grid)
    attempt_hash.each do |k, v|
      return false unless grid_hash.key?(k)
      return false if grid_hash[k] < v
    end
    true
  end
end
