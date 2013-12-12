class AddContentIdToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :content_id, :integer
  end

  def self.down
    remove_column :campaigns, :content_id
  end
end
