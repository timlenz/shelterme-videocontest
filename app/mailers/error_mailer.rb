class ErrorMailer < ActionMailer::Base
  default from: "info@shelterme.com"
  
  def error_notification(exception,user,page)
    @exception = exception
    @user = user
    @page = page
    exclude_error = "Missing template plays/create"
    unless @exception.message.html_safe.start_with?(exclude_error)
      mail to: 'admin@shelterme.com', subject: "Video Contest Error Encountered"
    end
  end
end
