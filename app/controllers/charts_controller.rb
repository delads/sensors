class ChartsController < ApplicationController
  def index
   @timeseries = TimeSeries.all
  end
  
end

