class PlaysController < ApplicationController
  
  respond_to :html, :js
  
  def create
    @video = Video.find(params[:play][:video_id])
    current_user.play!(@video)
  rescue
    null_user.play!(@video)
  end
end
