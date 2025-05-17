class MigrateExistingDataToMultipleOrganisations < ActiveRecord::Migration[8.0]
  def up
    # Create UserOrganisation records for existing user-organisation relationships
    execute <<-SQL
      INSERT INTO user_organisations (user_id, organisation_id, is_primary, created_at, updated_at)
      SELECT id, organisation_id, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM users
      WHERE organisation_id IS NOT NULL;
    SQL
    
    # Update all posts to reference the user's organisation
    execute <<-SQL
      UPDATE posts
      SET organisation_id = (
        SELECT organisation_id
        FROM users
        WHERE users.id = posts.user_id
      ),
      updated_at = CURRENT_TIMESTAMP
      WHERE EXISTS (
        SELECT 1
        FROM users
        WHERE users.id = posts.user_id
        AND users.organisation_id IS NOT NULL
      );
    SQL
  end

  def down
    # This migration is not reversible as it could lose data
    raise ActiveRecord::IrreversibleMigration
  end
end
