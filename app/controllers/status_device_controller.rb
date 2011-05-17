class StatusDeviceController < ApplicationController
  before_filter :parse_json_body
  before_filter :find_device
  before_filter :find_owned_resources
  before_filter :find_resource  
  before_filter :find_connections
  before_filter :find_connection

  def create
    render '/statuses/show'
  end


  private

    def find_device
      @device = json_body[:device]
    end

    def find_owned_resources
      @types  = Type.where(created_from: current_user.uri)
    end

    def find_resource
      @type = @types.where(uri: @device[:type][:uri]).first
      render_404 'notifications.connection.not_found', {uri: @device.type.uri} unless @type
    end

    def find_connections
      @statuses = @type.connected_statuses(true)
    end

    def find_connection
      puts "::::properties::::" + @device[:properties].inspect
      @status = Status.find_matching_status(@device[:properties], @statuses).first
      puts "::::status::::" + @status.inspect
    end
end
