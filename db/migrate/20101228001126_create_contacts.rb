class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :name
      t.text :description
      t.text :data
      t.integer :status, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
