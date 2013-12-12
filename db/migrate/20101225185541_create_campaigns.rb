class CreateCampaigns < ActiveRecord::Migration
  def self.up
    create_table :campaigns do |t|
      t.string :name
      t.string :description
      t.string :subject
      t.text :content_html
      t.text :content_text
      t.string :from_name
      t.string :from_email
      t.string :attachment
      t.string :content_type # htmltext, html, text (primary content type)
      t.integer :status # 0 - active, 1 - inactive, -1 - deleted
     
      #t.template_id :integer

      t.timestamps
    end
  end

  def self.down
    drop_table :campaigns
  end
end
