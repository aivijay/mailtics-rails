class CreateCampaignsCategories < ActiveRecord::Migration
  def self.up
    create_table :campaigns_categories, :id => false do |t|
      t.references :campaign
      t.references :category
    end
  end

  def self.down
    drop_table :campaigns_categories
  end
end
