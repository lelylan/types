class StatusDeviceController < ApplicationController

  before_filter :json_body, :init_properties
  before_filter :find_resource

  def create
    @accepted_statuses = find_status_for(@body[:device])
    @status = @accepted_statuses.first
    redirect_to @status.uri
  end


  private

    def find_resource
      @status = Status.owned_by(current_user).id(params[:id]).first
      render_404 "notifications.document.not_found", params[:id] unless @status
    end

    def init_properties
      @body[:device][:properties] ||= []
    end

    # ----------------------
    # Device's status search
    # ----------------------

    # TODO: move on status model where you should have something
    # like Status.find_matching(device)
    def find_status_for(device)
      device_properties = get_device_properties_from(device)
      statuses          = get_statuses_from(device)
      accepted_statuses = accept(device, statuses, device_properties)
    end

    # Define an hask where the key is the property_uri
    # and the value are the property info of the device
    def get_device_properties_from(device)
      device_properties = {}
      device[:properties].each do |property|
        uri = property[:uri]
        device_properties[uri] = property
      end
      return device_properties
    end

    # Retrieve all statuses associated to the device type
    def get_statuses_from(device)
      type_uri = device[:type][:uri]
      type = Type.owned_by(current_user).where(uri: type_uri).first
      uri_statuses = type.type_statuses.map(&:uri)
      statuses = Status.owned_by(current_user).where(:uri.in => uri_statuses).desc(:order).to_a
    end

    # Find the statuses that matches the device properties
    def accept(device, statuses, device_properties)
      accepted_statuses = []
      statuses.each do |status|
        passed = [true]
        status.status_properties.map do |status_property|
          property_uri    = status_property.uri
          status_values    = status_property.values
          property_value   = device_properties[property_uri][:value]
          property_pending = device_properties[property_uri][:pending]
          passed << ((status_values.include?(property_value) or status_values.empty?) and (status_property.pending == property_pending or status_property.pending.empty?))
        end
        accepted_statuses << status if (passed.inject(:&))
      end
      return accepted_statuses
    end

end
