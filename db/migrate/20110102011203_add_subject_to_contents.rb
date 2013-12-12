class AddSubjectToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :subject, :string
  end

  def self.down
    remove_column :contents, :subject
  end
end
