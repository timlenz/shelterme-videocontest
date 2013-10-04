# == Schema Information
#
# Table name: shares
#
#  id         :integer         not null, primary key
#  video_id   :integer
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Share < ActiveRecord::Base
  attr_accessible :user_id, :video_id
  
  belongs_to :user, counter_cache: true
  belongs_to :video, counter_cache: true
  
  validates :user_id, presence: true
  validates :video_id, presence: true
end
