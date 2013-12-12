class AddContactIdToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :contact_id, :integer
  end

  def self.down
    remove_column :campaigns, :contact_id
  end
end
