class ApisController < ApplicationController
  # before_action :doorkeeper_authorize!
  before_action :set_env
  before_action :set_maker, only: [:listthermostats, :describemaker, :settemperature]




  def setsensorpropertyvalue

    sensor = Sensor.find(params[:sensor_id])
    property_value = params[:property_value]
    sensor.property_value = property_value
    
    sensor.save
    render json: sensor
    
  end


  def createtimeseries
    sensor_id = params[:sensor_id]
    property_value = params[:property_value]

    # Hardcoding to Dublintime (UTC+1)
    time = Time.now.localtime("+01:00").rfc2822
    
    TimeSeries.create(:sensor_id => sensor_id, :property_value => property_value, :time => time);
    render json: TimeSeries.last

  end


# Legacy API calls


  def listthermostats
     render json: @maker.thermostats
    
  end
  
  def describemaker
    render json: @maker
  end

  
  def settemperature
     params[:id]
     
      thermostat = Thermostat.find(params[:id])
      target_temp = params[:target_temperature]
      thermostat.update_attribute(:max_temperature, target_temp)
      
      user = thermostat.mqtt_user
      password = thermostat.mqtt_password
      
      
      client = MQTT::Client.connect('mqtt://' + user + ':' + password + '@broker.shiftr.io')
      client.publish("max_temp",target_temp,true)
      client.disconnect()
      
 
      render json: thermostat
    
  end
  
  
  private
    
    def set_maker
      # @maker = Maker.find(session[:maker_id])
      @maker = Maker.find(doorkeeper_token.resource_owner_id)
    end
    
    private def set_env
      # @stripe_secret_api_key = ENV['STRIPE_SECRET_API_KEY_TEST']
      # @stripe_publishable_api_key = ENV['STRIPE_PUBLISHABLE_API_KEY_TEST']
      # @stripe_client_id = ENV['STRIPE_CLIENT_ID_TEST']
    end
end
  