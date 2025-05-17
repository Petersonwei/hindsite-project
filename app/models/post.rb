class Post < ApplicationRecord
  belongs_to :user
  belongs_to :organisation
  
  validates :description, presence: true
end
