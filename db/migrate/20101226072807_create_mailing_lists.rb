class CreateMailingLists < ActiveRecord::Migration
  def self.up
    create_table :mailing_lists do |t|
      t.string :name
      t.text :description
      t.text :data
      t.integer :status, :default => 1 # 1 - active, 0 - deleted, -1 - inactive

      t.timestamps
    end
  end

  def self.down
    drop_table :mailing_lists
  end
end
