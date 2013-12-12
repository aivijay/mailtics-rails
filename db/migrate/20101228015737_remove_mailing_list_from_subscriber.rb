class RemoveMailingListFromSubscriber < ActiveRecord::Migration
  def self.up
    remove_column :subscribers, :mailing_list_id
  end

  def self.down
    add_column :subscribers, :mailing_list_id, :integer
  end
end
