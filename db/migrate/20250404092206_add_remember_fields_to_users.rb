class AddRememberFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :remember_token, :text
    add_column :users, :remember_created_at, :datetime
  end
end
