# == Schema Information
#
# Table name: videos
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Video < ActiveRecord::Base
  attr_accessible :user_id
  
  belongs_to :user
  
  validates :user_id, presence: true
  
  default_scope order: 'videos.created_at DESC'
end
