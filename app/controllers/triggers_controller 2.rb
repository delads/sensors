class TriggersController < ApplicationController
before_action :set_trigger, only: [:edit, :update, :show, :like, :destroy]
before_action :require_same_user, only: [:edit, :update]
before_action :set_sensor, only: [:show, :destroy]

    
    def index
        
        @triggers = Trigger.all
    
    end
    
    def show
        @trigger = Trigger.find(params[:id])
    end
    
    def new
        @trigger = Trigger.new
        @sensor = Sensor.find(params[:sensor])
        
        
    end
    
    def create
        @trigger = Trigger.new(trigger_params)
     
        if @trigger.save
          flash[:success] = "Your trigger was created: " 
          redirect_to triggers_path
          
        else
          render :new
        end
    end
    

    
    def update
        if @trigger.update(trigger_params)
          
          
      
          user = @sensor.mqtt_user
          password = @sensor.mqtt_password
          
          trigger_value = @trigger.value
          trigger_id = @trigger.id
      
          client = MQTT::Client.connect('mqtt://' + user + ':' + password + '@broker.shiftr.io')
          client.publish("trigger_instruction_map","(" + trigger_id + "," + trigger_value + ")",true)
          client.disconnect()
          
          
          flash[:success] = "Your trigger was updated successfully!"
          redirect_to  trigger_path(@trigger)
        else
          render :edit
        end
    
    end
    
    def destroy
      
          user = @sensor.mqtt_user
          password = @sensor.mqtt_password

          trigger_id = @trigger.id
      
          client = MQTT::Client.connect('mqtt://' + user + ':' + password + '@broker.shiftr.io')
          client.publish("trigger_instruction_map","(" + trigger_id + ",destroy)",true)
          client.disconnect()
      
        Trigger.find(params[:id]).destroy
        flash[:success] = "Trigger deleted"
        redirect_to triggers_path
    end
    
    
  
    def trigger_params
      params.require(:trigger).permit(:name, :value, :webhook_url, :sensor_id)
    end
    
    def set_trigger
      @trigger = Trigger.find(params[:id])
    end
    
    
    def set_sensor
      @sensor = @trigger.sensor
    end
    
    
    def require_same_user
      if current_user != @sensor.maker
        flash[:danger] = "You can only edit your own products"
        redirect_to triggers_path
      end
    end


end