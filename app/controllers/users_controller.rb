class UsersController < ApplicationController
  before_filter :signed_in_user, 
                only: [:index, :update, :destroy, :videos]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :find_user, only: [:show, :destroy]
    
  respond_to :html, :js, only: [:update, :index]
  
  def show
    @videos = Video.where(user_id: @user.id).includes(:category, :user)
    @videos_count = @videos.count
    @videos = @videos.paginate(page: params[:videos_page], per_page: 12)
    @approved = Video.where(user_id: @user.id, approved: true).includes(:category, :user)
    @approved_count = @approved.count
    @approved = @approved.paginate(page: params[:videos_page], per_page: 12)
    # Get video ids from user plays
    @watched = Video.where(id: (Play.where(user_id: @user.id).map{|p| p.video_id}.uniq)).includes(:category, :user)
    @watched_count = @watched.count
    @watched = @watched.paginate(page: params[:watched_page], per_page: 12)
    @voted = Video.where(id: (Vote.where(user_id: @user.id).map{|p| p.video_id}.uniq)).includes(:category, :user)
    @voted_count = @voted.count
    @voted = @voted.paginate(page: params[:voted_page], per_page: 12)
    @shared = Video.where(id: (Share.where(user_id: @user.id).map{|p| p.video_id}.uniq)).includes(:category, :user)
    @shared_count = @shared.count
    @shared = @shared.paginate(page: params[:shared_page], per_page: 12)
    # flash[:notice] = "<p>You do not need to create an account to watch or share a video, but you must be signed 
    #                   in to vote for a video.</p><p>You may vote for a video once every 24 hours.</p>".html_safe
  rescue
    raise ActionController::RoutingError.new('Not Found')
  end
  
  def index
    if current_user.admin?
      @users = User.search(params[:search]).paginate(page: params[:page])
    else
      redirect_to root_path
    end
  end
  
  def contributors
    @contributors = User.where("videos_count > 0")
    @video_count = Video.where(approved: true).count
  end
  
  def new
    unless signed_in?
      @user = User.new
    else
      redirect_to watch_path
    end
  end
  
  def create
    unless signed_in?
      @user = User.new(params[:user])
      if @user.save
        sign_in @user
        redirect_to watch_path
      else
        render 'new'
      end
    else
      redirect_to watch_path
    end
  end
  
  def edit
    cookies[:avatar] = "false"
  rescue
    flash[:error] = "Unable to edit user profile."
    redirect_to :back
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name} has been deleted."
    redirect_to :back
  rescue
    flash[:notice] = "User not deleted."
    redirect_to :back
  end
  
  def update
    if @user.update_attributes(params[:user])
      if current_user == @user
        if cookies[:avatar] == "false"        
          redirect_to @user
          flash[:success] = "Your profile has been updated."
        else
          cookies[:avatar] = "false"
          redirect_to :back
          flash[:success] = "Your avatar has been updated."
        end
        sign_in @user
      else
        flash[:success] = "Profile for #{@user.name} has been updated."
        redirect_to @user
      end
    else
      render 'edit'
    end
    cookies.delete :location
  rescue
    flash[:notice] = "User not updated."
    redirect_to :back
  end
  
  def videos
    @user = current_user
    @videos = Video.where(user_id: @user.id).includes(:category, :user).paginate(page: params[:page], per_page: 12)
    @videos_count = @videos.count
    cookies[:editTitle] = "false"
  end
  
  private
    
    def correct_user
      @user = User.find_by_slug(params[:id])
      redirect_to(root_path) unless current_user?(@user) or current_user.admin?
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    def find_user
      @user = User.where('slug iLIKE ?', "#{params[:id]}").first
    end
end