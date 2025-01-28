class CreateCalendars < ActiveRecord::Migration[7.1]
  def change
    create_table :calendars do |t|
      t.string :title, null: false
      t.text :description
      t.integer :year, null: false

      t.timestamps
    end

    add_index :calendars, :year, unique: true
  end
end
