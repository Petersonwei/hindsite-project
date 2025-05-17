class User < ApplicationRecord
  belongs_to :organisation, optional: true
  has_many :user_organisations, dependent: :destroy
  has_many :organisations, through: :user_organisations
  has_many :posts, dependent: :destroy
  
  has_secure_password
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: ['active', 'departed'] }
  
  scope :active, -> { where(status: 'active') }
  scope :departed, -> { where(status: 'departed') }
  
  def primary_organisation
    user_organisations.find_by(is_primary: true)&.organisation || organisation
  end
  
  def primary_organisation=(org)
    return unless org
    
    user_organisations.where(is_primary: true).update_all(is_primary: false)
    
    user_org = user_organisations.find_or_create_by(organisation: org)
    user_org.update(is_primary: true)
  end
  
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
  
  def organisation_name
    primary_organisation&.name
  end
end
