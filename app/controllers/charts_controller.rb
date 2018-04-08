class ChartsController < ApplicationController
  def index

   # @timestamps = TimeSeries.pluck('created_at')
   # @values = TimeSeries.pluck('property_value')

   @timestamps = Array.new
   @values = Array.new

   # Let's create our arrays for the last 24 hours (by minute)

   t = Time.at((Time.now.to_i / 60.0).round * 60)
   $i = 0
   $num = 1440   # number of minutes in 24 hours
   minute_interval = 5


   t = t - ($num * 60)  # let's start at the earliest time. *60 for seconds

   while $i < $num  do
    t = t + (60* minute_interval)   # add 60 seconds 
    value = TimeSeries.where(:time => t).limit(1).pluck(:property_value).first

    @timestamps.push(t)
    @values.push(value.to_s)

    $i += minute_interval
   end

   @timeseries = TimeSeries.all


  end

  ##
  # rounds a Time or DateTime to the neares 15 minutes
  def round_to_1_minute(t)
    rounded = Time.at((t.to_time.to_i / 60.0).round * 60)
    t.is_a?(DateTime) ? rounded.to_datetime : rounded
  end

  
end

