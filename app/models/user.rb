# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  city                   :string(255)
#  bio                    :text
#  slug                   :string(255)
#  avatar                 :string(255)
#  admin                  :boolean         default(FALSE)
#  password_digest        :string(255)
#  remember_token         :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  date_of_birth          :datetime
#  phone                  :string(255)
#  zipcode                :string(255)
#  street                 :string(255)
#  state                  :string(255)
#  plays_count            :integer         default(0), not null
#  shares_count           :integer         default(0), not null
#  votes_count            :integer         default(0), not null
#  videos_count           :integer         default(0), not null
#

class User < ActiveRecord::Base
  attr_accessible :admin, :avatar, :bio, :email, :phone, :name,
                  :password_digest, :password_reset_sent_at, :password_reset_token, 
                  :remember_token, :slug, :password, :password_confirmation,
                  :street, :city, :state, :zipcode, :date_of_birth, :avatar_cache
  
  require 'obscenity/active_model'
  
  has_secure_password
  has_many :videos
  has_many :shares, dependent: :destroy
  has_many :plays, dependent: :destroy
  has_many :votes, dependent: :destroy
  
  before_save { |user| user.email = email.downcase }
  before_save { generate_token(:remember_token) }
    
  validates :name, presence: true,
            length: { maximum: 50 },
            obscenity: { sanitize: true, replacement: :garbled}
  validates :bio, length: { maximum: 480 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :slug, uniqueness: true, presence: true
  # validates :city, presence: true
  # validates :street, presence: true
  # validates :zipcode, presence: true
  # validates :state, presence: true
  # validates :date_of_birth, presence: true
  # validates :phone, presence: true
  
  # profanity_filter :name, :bio, :location
  mount_uploader :avatar, AvatarUploader
  
  before_validation :generate_slug, on: :create
  
  def to_param
    slug
  end
  
  def play!(video)
    plays.create!(video_id: video.id)
  end
  
  def share!(video)
    shares.create!(video_id: video.id)
  end  
  
  def vote!(video, value)
    votes.create!(video_id: video.id, value: value)
  end
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def self.search(search)
    if search
      where('name iLIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  private
    
    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end
    
    def generate_slug
      self.slug = name.parameterize.titleize.gsub(" ","")
      while User.find{|s| s.slug == self.slug} do
        self.slug = self.slug + Random.rand(1..9).to_s
      end
    end
end
