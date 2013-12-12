class CreateSchedulers < ActiveRecord::Migration
  def self.up
    create_table :schedulers do |t|
      t.integer :campaign_id
      t.integer :contact_id
      t.integer :content_id
      t.integer :supress_by
      t.string :priority, :default => 'normal'
      t.datetime :schedule_time
      t.integer :status, :default => 0
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :schedulers
  end
end
