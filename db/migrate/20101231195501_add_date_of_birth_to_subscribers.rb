class AddDateOfBirthToSubscribers < ActiveRecord::Migration
  def self.up
    add_column :subscribers, :dob, :datetime
  end

  def self.down
    remove_column :subscribers, :dob
  end
end
