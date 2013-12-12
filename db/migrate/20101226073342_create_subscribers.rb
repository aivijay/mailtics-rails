class CreateSubscribers < ActiveRecord::Migration
  def self.up
    create_table :subscribers do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.text :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.integer :status, :default => 1 # 1 actitve, 0 - deleted, -1 - inactive
      t.text :data

      t.timestamps
    end
  end

  def self.down
    drop_table :subscribers
  end
end
