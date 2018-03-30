class DashboardController < ApplicationController
  def index
    
    @sensor = Sensor.first
  end
  
  def update
  
    ## Let's connect to the MQTT server and send the new request
    MQTT::Client.connect('mqtt://1461c437:8f2cf8f35b34ee39@broker.shiftr.io') do |client|
      client.publish("max_temp","40", retain=false)
      client.disconnect()
    end
    
    redirect_to dashboard_path
  
  end
  
end

