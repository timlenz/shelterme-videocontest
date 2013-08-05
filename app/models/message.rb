class Message
  include ActiveAttr::Model
  
  attribute :name
  attribute :email
  attribute :content
  attribute :checker
  
  attr_accessible :name, :email, :content, :checker
  
  validates :name, presence: true
  validates :email, presence: true, 
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :content, presence: true
end
