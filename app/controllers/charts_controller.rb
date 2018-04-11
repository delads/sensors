class ChartsController < ApplicationController
  def index
    
  end

  def show

    @sensor = Sensor.find(params[:id])
    @timeseries = TimeSeries.where("sensor_id = '" + @sensor.id.to_s + "'")
  end
  
end

