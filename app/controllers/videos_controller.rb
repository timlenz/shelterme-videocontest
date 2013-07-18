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
      redirect_to enter_path
    end
    
  end
  
  def index
    
  end
  
  def watch
    
  end
end
