# == Schema Information
#
# Table name: votes
#
#  id         :integer         not null, primary key
#  video_id   :integer
#  user_id    :integer
#  value      :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Vote < ActiveRecord::Base
  attr_accessible :user_id, :video_id, :value

  belongs_to :user, counter_cache: true
  belongs_to :video, counter_cache: true

  validates :user_id, presence: true
  validates :video_id, presence: true
  validates :value, presence: true
end
