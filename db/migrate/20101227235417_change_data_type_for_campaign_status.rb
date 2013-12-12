class ChangeDataTypeForCampaignStatus < ActiveRecord::Migration
  def self.up
    change_table :campaigns do |t|
      t.change :status, :integer, :default => 1
    end
  end

  def self.down
  end
end
