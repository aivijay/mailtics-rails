class AddMailingListIdToSubscribers < ActiveRecord::Migration
  def self.up
    add_column :subscribers, :mailing_list_id, :integer
  end

  def self.down
    remove_column :subscribers, :mailing_list_id
  end
end
