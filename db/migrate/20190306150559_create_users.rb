class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :phone
      t.timestamps

      t.index :username
    end
  end
end
