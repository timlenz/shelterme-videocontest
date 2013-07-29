# == Schema Information
#
# Table name: videos
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  category_id  :integer
#  approved     :boolean         default(FALSE)
#  length       :float
#  views_count  :integer         default(0), not null
#  shares_count :integer         default(0), not null
#  votes_count  :integer         default(0), not null
#  title        :string(255)
#

class Video < ActiveRecord::Base
  attr_accessible :user_id
  
  belongs_to :user
  
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :length, presence: true
  validates :title, presence: true
  
  default_scope order: 'videos.created_at DESC'
end
