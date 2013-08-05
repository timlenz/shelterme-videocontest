module UsersHelper
  # If no user-specified avatar, use default image
  # Returns customized avatar from Cloudinary
  def avatar_for(user, options = {size: 40})
    size = options[:size]
    if user.avatar.blank?
      image_tag("blankProfile.png", alt: user.name, class: "avatar", style: "width:#{size}px;")
    else 
      cloudinary_url = user.avatar.to_s.gsub!(/upload/,"upload/a_exif,c_thumb,h_#{size},g_faces,w_#{size}")
      image_tag(cloudinary_url, alt: user.name, class: "avatar")
    end
  end
end