class SharesController < ApplicationController

  respond_to :html, :js
  
  def create
    @video = Video.find(params[:share][:video_id])
    current_user.share!(@video)
  rescue
    null_user.share!(@video)
  end
end
