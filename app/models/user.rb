class User < ApplicationRecord
  belongs_to :organisation, optional: true
  has_many :posts, dependent: :destroy
  
  has_secure_password
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
end
