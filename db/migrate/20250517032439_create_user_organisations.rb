class CreateUserOrganisations < ActiveRecord::Migration[8.0]
  def change
    create_table :user_organisations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organisation, null: false, foreign_key: true
      t.boolean :is_primary, default: false

      t.timestamps
    end
    
    add_index :user_organisations, [:user_id, :organisation_id], unique: true
  end
end
