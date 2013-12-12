class ChangeDataTypeForCampaignContentType < ActiveRecord::Migration
  def self.up
    change_table :campaigns do |t|
      t.change :content_type, :string, :default => 'HTMLTEXT'
    end
  end

  def self.down
  end
end
