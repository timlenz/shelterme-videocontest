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
    # Eliminate skew introduced by ballot stuffing
    sav = Vote.where(video_id: id).map{|v| v.value}.sort
    sav_all = sav.count
    sav_1 = sav.select{|v| v == 1}.count
    sav_2 = sav.select{|v| v == 2}.count
    sav_5 = sav.select{|v| v == 5}.count
    sav_12 = sav_1 + sav_2
    sav_14 = sav.select{|v| v < 5}.count
    sav_24 = sav.select{|v| v > 1 && v < 5}.count
    if sav_14 > 0
      top_rest = sav_5 / sav_14
    else
      top_rest = 0
    end
    if sav_12 > 0
      top_low = sav_5 / sav_12
    else
      top_low = 0
    end
    if top_rest == 0
      sav_cap = sav_all
      sav_floor = 0
    elsif top_rest <= 2
      sav_cap = sav_all
      if top_low < 1  # possibly bad video, include all votes
        sav_floor = 0
      else  # deflated video, exclude most low-end votes
        sav_floor = sav_1 + (sav_2 / 2).round
      end
    elsif top_rest <= 5
      sav_cap = sav_all - sav_24 # mixed inflation & deflation, slight trimming of top and bottom
      if sav_1 > sav_24
        sav_floor = sav_1 - sav_24
      else
        sav_floor = 0
      end
    else
      sav_cap = sav_all - (sav_5 / 2).round # significantly inflated, discard half of top votes
      sav_floor = 0
    end
    
    tav = sav[sav_floor..sav_cap].inject(:+).to_f / (sav_cap - sav_floor)
    
    self.ave_vote = tav
    self.save
  end
  
  private
  
    def store_video_duration
      self.length = self.duration.to_i
    end
    
end
