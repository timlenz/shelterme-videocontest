class MessagesController < ApplicationController
  def new
    @message = Message.new
  end
  
  def create
    @message = Message.new(params[:message])
    if @message.valid? && @message.checker.blank?
      MessageMailer.send_message(@message).deliver
      redirect_to contact_path, notice: "Your message has been sent. Thank you for contacting us."
    else
      render 'new'
    end
  rescue
    flash[:notice] = "Message not sent."
    render 'new'
  end
end
