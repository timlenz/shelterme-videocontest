class VideoMailer < ActionMailer::Base
  default from: "info@shelterme.com"
  
  def new_video(video, user)
    @video = video
    @user = user
    mail to: 'admin@shelterme.com', subject: "New video contest submission"
  end

  def approved_video(video)
    @video = video
    @user = @video.user
    mail to: @user.email, subject: "Shelter Me video contest submission approved"
  end
end
