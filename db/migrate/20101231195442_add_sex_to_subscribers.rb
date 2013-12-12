class AddSexToSubscribers < ActiveRecord::Migration
  def self.up
    add_column :subscribers, :sex, :string
  end

  def self.down
    remove_column :subscribers, :sex
  end
end
