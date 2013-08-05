class VideosController < ApplicationController
  before_filter :signed_in_user, only: [:create, :edit, :new]
  
  respond_to :html, :js
  
  def new
    @user = current_user
    @video = Video.new(user_id: @user.id)
  rescue
    flash[:error] = "Unable to add video."
    redirect_to :back
  end
  
  def addvideo
    if signed_in?
      # add functionality here
    else
      flash[:notice] = "You must be signed in to access this page."
      redirect_to signin_path
    end
  end
  
  def create
    @user = current_user
    @video = Video.create!(params[:video])
    if @video.save
      flash[:notice] = "Your video entitled '#{@video.title}' was added."
    else
      flash[:notice] = "Upload of video failed."
    end
    redirect_to myvideos_path
  rescue
    flash[:error] = "Unable to add your video."
    redirect_to addvideo_path
  end
  
  def update
    @video = Video.find(params[:id])
    if @video.update_attributes(params[:video])
      redirect_to :back
    else
      redirect_to allvideos_path
    end
  rescue
    if @video
      flash[:error] = "Unable to update #{@video.title}."
    else
      flash[:error] = "Unable to update video."
    end
    redirect_to :back
  end
  
  def destroy
    @video = Video.find(params[:id])
    Panda::Video.delete(@video.panda_video_id)
    @video.destroy
    flash[:notice] = "'#{@video.title}' deleted."
  rescue
    if @video
      flash[:error] = "Unable to delete #{@video.title}."
    else
      flash[:error] = "Unable to delete video."
    end
    redirect_to :back
  end
  
  def index
    if signed_in? && current_user.admin?
      @videos = Video.includes(:user).paginate(page: params[:page], per_page: 12)
    else
      redirect_to root_path
    end
  rescue
    flash[:error] = "Unable to display pet videos."
    redirect_to root_path
  end
  
  def watch
    @videos = Video.where(approved: true).paginate(page: params[:all_videos], per_page: 12)
    @new_videos = Video.where(created_at: 7.days.ago.utc...Time.now.utc, approved: true).paginate(page: params[:new_videos], per_page: 12)
    @rated_videos = []#Video.rated.paginate(page: params[:rated_videos], per_page: 12)
    @voted_videos = []#Video.voted.paginate(page: params[:voted_videos], per_page: 12)
    @viewed_videos = []#Video.all.sort_by{|e| -e[:views_count]}.paginate(page: params[:viewed_videos], per_page: 12)
    @shared_videos = []#Video.all.sort_by{|e| -e[:shares_count]}.paginate(page: params[:shared_videos], per_page: 12)
  end
end
