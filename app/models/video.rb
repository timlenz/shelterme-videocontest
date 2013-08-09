# == Schema Information
#
# Table name: videos
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  category_id    :integer
#  approved       :boolean         default(FALSE)
#  length         :float
#  views_count    :integer         default(0), not null
#  shares_count   :integer         default(0), not null
#  votes_count    :integer         default(0), not null
#  title          :string(255)
#  panda_video_id :string(255)
#

class Video < ActiveRecord::Base
  attr_accessible :user_id, :category_id, :title, :approved, :length, :panda_video_id,
                  :views_count, :shares_count, :votes_count
    
  has_many :shares
  has_many :views
  has_many :votes
  
  belongs_to :user
  belongs_to :category
  
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, presence: true
  validates :panda_video_id, presence: true, on: :create
  
  # GENERATE LENGTH ON CREATE DYNAMICALLY FROM PANDA VIDEO OBJECT - DURATION BELOW
  
  default_scope order: 'videos.created_at DESC'
  
  def duration
     Panda::Video.find(panda_video_id).duration / 1000
  end
  
  def panda_video
    @panda_video ||= Panda::Video.find(panda_video_id)
  end
  
  def h264
    @h264 = @panda_video.encodings["h264"]
  end
  
  def thumbnail
    @thumbnail = @panda_video.encodings["thumbnail"]
  end
  
  def ranking  # Return a value of 1 through 4 depending upon the overall rating of a video
    ranking = 1
  end
  
  def self.search(search)
    if search && search != 'all'
      where(approved: search)
    else
      scoped
    end
  end
end
