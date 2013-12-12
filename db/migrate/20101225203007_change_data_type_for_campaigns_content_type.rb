class ChangeDataTypeForCampaignsContentType < ActiveRecord::Migration
  def self.up
    change_table :campaigns do |t|
      t.change :content_type, :string, :default => "TEXT"
    end
  end

  def self.down
  end
end
