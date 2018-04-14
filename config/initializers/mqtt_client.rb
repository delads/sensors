
require 'mqtt'
require 'net/https'
require 'uri'


 @sensors = Sensor.all
  
@sensors.each do |s|
  
  Thread.new do 

    namespace = s.namespace
    mqtt_token = s.mqtt_token
    mqtt_topic = s.mqtt_topic

   # mqtt_token = "mqtt://delads:dd31d3fbed2942fa8e8d7eb6ac6d6eee@io.adafruit.com"
   # mqtt_topic = "delads/feeds/temperature"

  
    
    MQTT::Client.connect(mqtt_token) do |c|
        
         c.subscribe(mqtt_topic)       
         puts ("MQTT_CLIENT Thread started : " + s.name);
        
        ## Let's send a trigger to IFTTT if max temp is reached
        c.get do |topic,message|
          puts "#{topic}: #{message}"
     
          
          if(topic == mqtt_topic)

            time = Time.now.rfc2822
          #  rounded = Time.at((t.to_time.to_i / 60.0).round * 60)

            s.update_attribute(:property_value, message) 
            TimeSeries.create(:sensor_id => s.id, :property_value => message, :time => time);
 
          end
        end
    end
  end  # end thread
end # end looping through all thermostats

# rounds a Time or DateTime to the neares 15 minutes
# def round_to_1_minute(t)
#  rounded = Time.at((t.to_time.to_i / 60.0).round * 60)
#  t.is_a?(DateTime) ? rounded.to_datetime : rounded
# end

