class CreateContactsSubscribers < ActiveRecord::Migration
  def self.up
    create_table :contacts_subscribers, :id => false do |t|
      t.references :contact
      t.references :subscriber
    end
  end

  def self.down
    drop_table :contacts_subscribers
  end
end
