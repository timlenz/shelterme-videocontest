class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :render_error
    rescue_from ActiveRecord::RecordNotFound, with: :routing_error
    rescue_from ActionController::RoutingError, with: :routing_error
    rescue_from ActionController::UnknownController, with: :routing_error
    rescue_from AbstractController::ActionNotFound, with: :routing_error
  end
  
  private
  
    def handle_mobile
      request.format = :mobile if mobile_user_agent?
    end

    def mobile_user_agent?
      @mobile_user_agent ||= ( request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone|iPod|iPad|Android|BlackBerry)/] )
    end

    def canonical_url(canonical_url)
      @canonical_url = canonical_url
    end
    
    def routing_error(exception)
      logger.warn "#{exception.message}"
      render file: "/errors/404"
    end

    def render_error(exception)
      logger.warn "#{exception.message}"
      ErrorMailer.error_notification(exception,current_user,request.fullpath).deliver
      render file: "/errors/500", layout: false
    end
end
