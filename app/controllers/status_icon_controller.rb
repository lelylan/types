class StatusIconController < ApplicationController

  rescue_from ArgumentError, with: :resize_not_valid
  before_filter :find_resource, only: ["show", "update"]

  def show
    @icon = @status.icon.thumb(params[:size] ||= "128x128")
    redirect_to @icon.url if @icon.file
  end

  def update
    @status.icon = params[:icon]
    if @status.save
      render "statuses/show", status: 200, location: @status.uri
    else
      render_422 "notifications.document.not_valid", @status.errors
    end
  end


  private

    def find_resource
      @status = Status.owned_by(current_user).id(params[:id]).first
      render_404 "notifications.document.not_found", params[:id]   unless @status
    end

end
