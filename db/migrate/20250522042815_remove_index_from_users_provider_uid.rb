class RemoveIndexFromUsersProviderUid < ActiveRecord::Migration[8.0]
  def change
    remove_index :users, :provider_uid
  end
end
