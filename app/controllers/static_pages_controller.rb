class StaticPagesController < ApplicationController
  def new
  end
  
  def statistics
    unless signed_in? && current_user.admin? 
      redirect_to root_path
    end
  end
end
