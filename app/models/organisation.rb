class Organisation < ApplicationRecord
  # Keep existing relationship for backwards compatibility
  has_many :users
  
  # Add the many-to-many relationship
  has_many :user_organisations, dependent: :destroy
  has_many :members, through: :user_organisations, source: :user
  
  # Direct posts relationship
  has_many :posts, dependent: :destroy
  
  validates :name, presence: true
end
