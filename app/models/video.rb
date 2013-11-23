# == Schema Information
#
# Table name: videos
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  category_id     :integer
#  approved        :boolean         default(FALSE)
#  length          :float
#  plays_count     :integer         default(0), not null
#  shares_count    :integer         default(0), not null
#  votes_count     :integer         default(0), not null
#  title           :string(255)
#  panda_video_id  :string(255)
#  ave_vote        :float           default(0.0)
#  rating          :float
#  plays_quartile  :integer
#  shares_quartile :integer
#  votes_quartile  :integer
#

class Video < ActiveRecord::Base
  attr_accessible :user_id, :category_id, :title, :approved, :length, :panda_video_id,
                  :plays_count, :shares_count, :votes_count
    
  has_many :shares, dependent: :destroy
  has_many :plays, dependent: :destroy
  has_many :votes, dependent: :destroy
  
  belongs_to :user, counter_cache: true
  belongs_to :category
  
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, presence: true
  validates :panda_video_id, presence: true, on: :create
  
  before_create :store_video_duration
  
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
  
  def webm
    @webm = @panda_video.encodings["webm"]
  end
  
  def thumbnail
    @thumbnail = @panda_video.encodings["thumbnail"]
  end
  
  def self.text_search(query)
    rank = <<-RANK
    ts_rank(to_tsvector(title), plainto_tsquery(#{sanitize(query)}))
    RANK
    where("title @@ :q", q: query).order("#{rank} desc")
  end
  
  def self.search(search)
    if search && search != 'all'
      where(approved: search)
    else
      scoped
    end
  end
  
  def calculate_ave_vote
    # Eliminate all votes with value 1 from calculation and subtract same number of top votes
    # Check if value(1).count > value(2-4).count, & if so, reject value(1) votes & same # of top votes
    # Else, if value(5).count > value(1-4).count*4, reject # of value(5) votes equal to value(1-4).count
    # av = Vote.where(video_id: id).map{|v| v.value}
    # sav = av.sort
    # sav_size = sav.count
    # sav_cheat = sav.select{|v| v == 1}.count
    # sav_cap = sav_size - sav_cheat
    # tav = sav[(sav_cheat + 1)..sav_cap].inject(:+).to_f / (sav_size - 2 * sav_cheat)
    
    average_vote = Vote.average(:value, conditions: ['video_id = ?', id]).to_f
    self.ave_vote = average_vote
    # self.ave_vote = tav
    self.save
  end
  
  private
  
    def store_video_duration
      self.length = self.duration.to_i
    end
    
end
