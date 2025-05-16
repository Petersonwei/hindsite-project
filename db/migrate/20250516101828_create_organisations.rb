class CreateOrganisations < ActiveRecord::Migration[8.0]
  def change
    create_table :organisations do |t|
      t.string :name
      t.string :country
      t.string :language

      t.timestamps
    end
  end
end
