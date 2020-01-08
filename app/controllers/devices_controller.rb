class DevicesController < ApplicationController

	before_action :authenticate_user!

	def index
		@devices = Device.all
	end


	def new
		@device = Device.new
	end

	def create
		@device = Device.new(device_params)

		@device.save

		redirect_to @device
	end

	def show
		@device = Device.find(params[:id])
	end

	def edit
		@device = Device.find(params[:id])
	end

	def update
    @device = Device.find(params[:id])

    if @device.update(device_params)
      redirect_to @device
    else
      render 'edit'
    end
  end

	def destroy
		@device = Device.find(params[:id])
		@device.destroy

		redirect_to devices_path
	end


	def trigger_on_command
		trigger
	end

	def trigger_off_command
		trigger
	end

	private
		def device_params
	    params.require(:device).permit(:device_name, :device_type, :device_location, :on_command, :off_command)
	  end

	  def trigger
	  	@device = Device.find(params[:id])
	  	instruction = params[:action].split('_')[1]
	  	# action can be: trigger_on_command / trigger_off_command
			cmd = case instruction
						when "on"
							@device.on_command
						when "off"
							@device.off_command
						else
							""
						end

			job1 = fork do
			  system(cmd)
			end
			Process.detach(job1)
			message = "Turning #{@device.device_name} #{instruction.upcase}"
			flash[:primary] = message
			redirect_to devices_path
		end

end
