class PlaysController < ApplicationController
  
  respond_to :html, :js
  
  def create
    @video = Video.find(params[:play][:video_id])
    # check if current_user has shared this video (very) recently
    if signed_in?
      play_check = Play.where(video_id: @video.id, user_id: current_user.id).last
      if play_check.nil? || play_check.created_at < 1.minute.ago
        current_user.play!(@video)
      end
    else
      play_check = Play.where(video_id: @video.id, user_id: null_user.id).last
      if play_check.nil? || play_check.created_at < 30.seconds.ago
        null_user.play!(@video)
      end      
    end
  end
  
end
