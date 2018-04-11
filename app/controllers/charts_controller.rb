class ChartsController < ApplicationController
  def index
    
  end

  def show

    @sensor = Sensor.find(params[:id])
    @timeseries = TimeSeries.find_by_sql("Select * from time_series where sensor_id = " + @sensor.id.to_s)
  end
  
end

