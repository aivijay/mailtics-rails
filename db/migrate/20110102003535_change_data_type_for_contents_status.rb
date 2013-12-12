class ChangeDataTypeForContentsStatus < ActiveRecord::Migration
  def self.up
    change_table :contents do |t|
      t.change :status, :integer, :default => 1
    end
  end

  def self.down
  end
end
