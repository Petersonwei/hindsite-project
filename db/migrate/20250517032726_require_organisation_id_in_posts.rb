class RequireOrganisationIdInPosts < ActiveRecord::Migration[8.0]
  def change
    # Now that we've migrated data, we can make organisation_id required
    change_column_null :posts, :organisation_id, false
  end
end
