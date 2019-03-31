class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :start_time
      t.datetime :end_time
      t.string :description
      t.boolean :all_day
      t.text :rsvps
      t.boolean :completed
      t.timestamps

      t.index :start_time
    end
  end
end
