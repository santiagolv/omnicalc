class CalculationsController < ApplicationController

  def word_count
    @text = params[:user_text]
    @special_word = params[:user_word]

    text_splitted = @text.gsub("\n"," ").squish.upcase.split
    text_splitted_length = text_splitted.length
    counter = 0
    special_word_occurrences = 0
    while counter < text_splitted_length do
      if text_splitted[counter]==@special_word.upcase || text_splitted[counter]==@special_word.upcase+";"|| text_splitted[counter]==@special_word.upcase+":"|| text_splitted[counter]==@special_word.upcase+"!"|| text_splitted[counter]==@special_word.upcase+"?"|| text_splitted[counter]==@special_word.upcase+"."|| text_splitted[counter]==@special_word.upcase+","
        counter += 1
        special_word_occurrences += 1
      else
        counter += 1
      end
    end
    text_chomped = @text.gsub("\n"," ")

    @character_count_with_spaces = text_chomped.length
    @character_count_without_spaces = text_chomped.gsub(/\s+/,"").length
    @word_count = @text.squish.count(" ")+1
    @occurrences = special_word_occurrences

    render("word_count.html.erb")
  end

  def loan_payment
    @apr = params[:annual_percentage_rate].to_f
    @years = params[:number_of_years].to_i
    @principal = params[:principal_value].to_f

    @monthly_payment = (@apr/100.0/12)*@principal / (1-(1+@apr/100.0/12)**(@years*-1.0*12))

    render("loan_payment.html.erb")
  end

  def time_between
    @starting = Chronic.parse(params[:starting_time])
    @ending = Chronic.parse(params[:ending_time])

    @seconds = @ending-@starting
    @minutes = (@ending-@starting)/60
    @hours = (@ending-@starting)/60/60
    @days = (@ending-@starting)/60/60/24
    @weeks = (@ending-@starting)/60/60/24/7
    @years = (@ending-@starting)/60/60/24/365.25

    render("time_between.html.erb")
  end

  def descriptive_statistics
    @numbers = params[:list_of_numbers].gsub(',','').split.map(&:to_f)
    numbers_sorted = params[:list_of_numbers].gsub(',','').split.map(&:to_f).sort!

    @sorted_numbers = numbers_sorted

    @count = numbers_sorted.length

    @minimum = numbers_sorted.min

    @maximum = numbers_sorted.max

    @range = numbers_sorted.max - numbers_sorted.min

    if numbers_sorted.length.odd?
      @median = numbers_sorted[(numbers_sorted.length/2).to_i]
    else
      @median = (numbers_sorted[numbers_sorted.length/2-1].to_f + numbers_sorted[numbers_sorted.length/2].to_f)/2
    end

    @sum = numbers_sorted.sum

    @mean = numbers_sorted.sum/numbers_sorted.length

    local_variance = 0

    numbers_sorted.each do |i|
      local_variance=local_variance + (i-@mean)**2.0
    end
    local_variance = local_variance/numbers_sorted.length
    @variance = local_variance

    @standard_deviation = local_variance**0.5

    freq = numbers_sorted.inject(Hash.new(0)) {|h,v| h[v]+=1; h}

    @mode = numbers_sorted.max_by {|v| freq[v]}

    # ================================================================================
    # Your code goes above.
    # ================================================================================

    render("descriptive_statistics.html.erb")
  end
end
