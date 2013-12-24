class PlaysController < ApplicationController

  before_filter :admin_user, only: [:create]  # Bot prevention after contest closure
  
  respond_to :js, only: [:create]
  
  def create
    @video = Video.find(params[:play][:video_id])
    # check if current_user has shared this video (very) recently
    if signed_in?
      play_check = Play.where(video_id: @video.id, user_id: current_user.id).last
      if play_check.nil? || play_check.created_at < @video.length.seconds.ago
        current_user.play!(@video)
      else
        # do nothing if attempting to play too quickly
        return false
      end
    else
      play_check = Play.where(video_id: @video.id, user_id: null_user.id).last
      if play_check.nil? || play_check.created_at < 30.seconds.ago
        null_user.play!(@video)
      else
        # do nothing if attempting to play too quickly
        return false
      end      
    end
  end
  
end
