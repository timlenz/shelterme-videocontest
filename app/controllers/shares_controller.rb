class SharesController < ApplicationController

  respond_to :html, :js
  
  def create
    @video = Video.find(params[:share][:video_id])
    # check if current_user has shared this video (very) recently
    if signed_in?
      share_check = Share.where(video_id: @video.id, user_id: current_user.id).last
      if share_check.nil? || share_check.created_at < 10.seconds.ago
        current_user.share!(@video)
      end
    else
      share_check = Share.where(video_id: @video.id, user_id: null_user.id).last
      if share_check.nil? || share_check.created_at < 10.seconds.ago
        null_user.share!(@video)
      end
    end
  end
  
end
