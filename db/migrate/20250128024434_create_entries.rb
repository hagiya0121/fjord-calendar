class CreateEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :entries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :calendar, null: false, foreign_key: true
      t.string :title, null: false
      t.string :url
      t.date :registration_date, null: false
      t.string :meta_title
      t.string :meta_description
      t.text :meta_image_url

      t.timestamps
    end
  end
end
