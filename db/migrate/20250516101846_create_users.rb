class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.references :organisation, null: true, foreign_key: true

      t.timestamps
    end
  end
end
