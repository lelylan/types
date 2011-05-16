class StatusImageController < ApplicationController
  before_filter :find_owned_resources
  before_filter :find_resource
  before_filter :normalize_size

  def show
    redirect_to @status.image_url(params[:size])
  end

  def create
    @status.image = params[:image]
    if @status.save
      render '/statuses/show', status: 201, location: @status.uri
    else
      render_422 'notifications.document.not_valid', @status.errors
    end
  end

  def destroy
    @status.remove_image = true
    @status.save
    redirect_to @status.image_url(params[:size])
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
        render_404 'notifications.image.not_found', {size: params[:size]}
      end
    end
end
