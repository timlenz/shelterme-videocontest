class VotesController < ApplicationController
  
  respond_to :html, :js
  
  def create
    @video = Video.find(params[:vote][:video_id])
    # check if current_user has voted for this video in the last day
    vote_check = Vote.where(video_id: @video.id, user_id: current_user.id).last
    if vote_check.nil? || vote_check.created_at.utc < 1.day.ago
      current_user.vote!(@video, params[:vote][:value])
      @video.calculate_ave_vote
    else
      # Not displaying - figure out why
      flash[:notice] = "You have already voted for this video today."
    end
  end
end
