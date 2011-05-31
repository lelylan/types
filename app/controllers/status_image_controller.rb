class StatusImageController < ApplicationController
  before_filter :find_owned_resources
  before_filter :find_resource
  before_filter :normalize_size, only: :show

  def show
    redirect_to @status.image_url(params[:size])
  end

  # @note: this method can be called through curl using the following command lines:
  # curl -u alice@example.com:example -s -F "image=@spec/fixtures/example.png;type=image/png" -X PUT http://localhost:3000/statuses/4de3d3ecd033a982850001d9/image
  # curl -u alice@example.com:example -s -F "image=@spec/fixtures/example.png" -X PUT http://localhost:3000/statuses/4de3d3ecd033a982850001d9/image
  #
  # The as content-type (which is defined after the file name) you can put also application/json
  # and it will work, because the important part is that the file is encoded raw multipart data.
  # As explained here http://www.ietf.org/rfc/rfc2388.txt the multipart data encoding gives all
  # the needed information for the uploading system.
  def update
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
    render '/statuses/show'
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
