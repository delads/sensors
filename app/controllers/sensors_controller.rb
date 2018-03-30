class SensorsController < ApplicationController
before_action :set_sensor, only: [:edit, :update, :show, :like, :destroy]
before_action :require_same_user, only: [:edit, :update]
before_action :set_maker, only: [:show, :destroy]
before_action :build_sensor_map

    
    def index
        
        @sensors = Sensor.all
    
    end
    
    def show
        @sensor = Sensor.find(params[:id])
        @triggers = @sensor.triggers
        
        @shiftrsrc = "https://shiftr.io/" + @sensor.namespace + "/embed?zoom=1"
    end
    
    def temp
        @sensor = Sensor.find(params[:id])
        render :text => @sensor.property.value
    end
    
    def new
        @sensor = Sensor.new   
    end
    
    def create
        @sensor = Sensor.new(sensor_params)
        @sensor.maker = current_user
     
        if @sensor.save
          flash[:success] = "Your sensor was created: " 
          redirect_to root_path
          
        else
          render :new
        end
    end
    

    
    def update
        if @sensor.update(sensor_params)
          
          
      
          user = @sensor.mqtt_user
          password = @sensor.mqtt_password
          target_temp = @sensor.max_temperature
      
          client = MQTT::Client.connect('mqtt://' + user + ':' + password + '@broker.shiftr.io')
          client.publish("max_temp",target_temp,true)
          client.disconnect()
          
          
          flash[:success] = "Your thermmostat was updated successfully!"
          redirect_to  sensor_path(@sensor)
        else
          render :edit
        end
    
    end
    
    def destroy
        Sensor.find(params[:id]).destroy
        flash[:success] = "Sensor deleted"
        redirect_to sensors_path
    end
    
    
  
    def sensor_params
      params.require(:sensor).permit(:name, :sensor_type, :namespace, :mqtt_token, :mqtt_topic)
    end
    
    def set_sensor
      @sensor = Sensor.find(params[:id])
    end
    
    
    def set_maker
      @maker = @sensor.maker
    end
    
    
    def require_same_user
      if current_user != @sensor.maker
        flash[:danger] = "You can only edit your own products"
        redirect_to sensors_path
      end
    end

    def build_sensor_map
      @sensor_class = Hash.new
      @sensor_class["Temperature"] = "fa fa-thermometer-3 fa-5x"
      @sensor_class["Humidity"] = "wi wi-humidity fa-5x"
      @sensor_class["Pressure"] = "wi wi-barometer fa-5x"
    end


end