class VotesController < ApplicationController
  # before_filter :signed_in_user, only: [:create]
  before_filter :admin_user, only: [:create]  # Bot prevention after contest closure
  
  respond_to :html, :js
  
  def create
    @video = Video.find(params[:vote][:video_id])
    # check if current_user has voted for this video in the last day
    vote_check = Vote.where(video_id: @video.id, user_id: current_user.id).last
    if vote_check.nil? || vote_check.created_at.utc < 1.day.ago
      current_user.vote!(@video, params[:vote][:value])
      @video.calculate_ave_vote
    end
  end
  
end
