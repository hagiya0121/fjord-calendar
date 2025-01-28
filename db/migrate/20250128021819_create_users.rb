class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :provider_uid, null: false
      t.string :avatar_url
      t.integer :role, default: 0

      t.timestamps
    end

    add_index :users, :provider_uid, unique: true
  end
end
