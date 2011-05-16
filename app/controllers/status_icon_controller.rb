class StatusIconController < ApplicationController
  before_filter :find_owned_resources
  before_filter :find_resource
  before_filter :normalize_size

  def show
    puts ":::::" +  @status.image_url(params[:size]).inspect
    redirect_to @status.image_url(params[:size])
  end

  def create
    @status.icon = params[:icon]
    if @status.save
      render "/statuses/show", status: 201, location: @status.uri
    else
      render_422 "notifications.document.not_valid", @status.errors
    end
  end


  private

    def find_owned_resources
      @statuses = Status.where(created_from: current_user.uri)
    end

    def find_resource
      @status = @statuses.find(params[:id])
    end

    def normalize_size
      params[:size] = 'medium' unless params[:size]
      unless Settings.thumbs.sizes.include?(params[:size])
        render_404 'notifications.icon.not_found', {size: params[:size]}
      end
    end
end
