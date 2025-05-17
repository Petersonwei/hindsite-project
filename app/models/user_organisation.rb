class UserOrganisation < ApplicationRecord
  belongs_to :user
  belongs_to :organisation
  
  validates :user_id, uniqueness: { scope: :organisation_id }
  
  # Ensure only one primary org per user
  after_save :ensure_single_primary, if: -> { is_primary? }
  
  private
  
  def ensure_single_primary
    return unless is_primary?
    user.user_organisations
        .where.not(id: id)
        .where(is_primary: true)
        .update_all(is_primary: false)
  end
end
