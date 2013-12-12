class AddPublishedAtToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :published_at, :datetime
  end

  def self.down
    remove_column :campaigns, :published_at
  end
end
