# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  location               :string(255)
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
#

class User < ActiveRecord::Base
  attr_accessible :admin, :avatar, :bio, :email, :location, :name,
                  :password_digest, :password_reset_sent_at, :password_reset_token, 
                  :remember_token, :slug, :password, :password_confirmation
  
  require 'obscenity/active_model'
  
  has_secure_password
  # has_many :videos
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
  
  # profanity_filter :name, :bio, :location
  # mount_uploader :avatar, AvatarUploader
  
  before_validation :generate_slug, on: :create
  
  def to_param
    slug
  end
  
  private
  
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
