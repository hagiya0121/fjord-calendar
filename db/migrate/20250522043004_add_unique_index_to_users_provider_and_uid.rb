class AddUniqueIndexToUsersProviderAndUid < ActiveRecord::Migration[8.0]
  def change
    add_index :users, [:provider, :provider_uid], unique: true
  end
end
