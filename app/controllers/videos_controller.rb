class VideosController < ApplicationController
  before_filter :signed_in_user, only: [:create, :edit]
  
  def new
    
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
