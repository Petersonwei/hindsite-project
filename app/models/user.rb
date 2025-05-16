class User < ApplicationRecord
  belongs_to :organisation, optional: true
  has_many :posts, dependent: :destroy
  
  has_secure_password
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: ['active', 'departed'] }
  
  scope :active, -> { where(status: 'active') }
  scope :departed, -> { where(status: 'departed') }
  
  def active?
    status == 'active'
  end
  
  def departed?
    status == 'departed'
  end
  
  def depart!
    update(status: 'departed')
  end
  
  def reactivate!
    update(status: 'active')
  end
end
