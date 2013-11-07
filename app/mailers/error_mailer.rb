class ErrorMailer < ActionMailer::Base
  default from: "info@shelterme.com"
  
  def error_notification(exception,user,page)
    @exception = exception
    @user = user
    @page = page
    exclude_page = "/plays"
    unless @page = exclude_page
      mail to: 'admin@shelterme.com', subject: "Video Contest Error Encountered"
    end
  end
end
