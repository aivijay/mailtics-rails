# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

user = User.create :email => 'admin@mailtics.com', 
                   :password => 'admin1',
                   :password_confirmation => 'admin1'
Category.create [{:name => 'Newsletter'},
                 {:name => 'Promotions'},
                 {:name => 'Festivals'},
                 {:name => 'Valued Customers'},
                 {:name => 'Announcements'},
                 {:name => 'Survey'}]
user.campaigns.create :name => 'Newsletter for month Nov 2010',
                      :description => 'Mailtics newsletter for month of Nov 2010',
                      :content_html => 'Our newsletter for Nov 2010 is here for you',
                      :content_text => 'Our newsletter for Nov 2010 is here for you',
                      :from_email => 'support@mailtics.com',
                      :from_name => 'Mailtics Support',
                      :subject => 'Newsletter for the month of Nov 2010',
                      :published_at => Date.today
user.campaigns.create :name => 'Newsletter for month Dec 2010',
                      :description => 'Mailtics newsletter for month of Dec 2010',
                      :content_html => 'Our newsletter for Dec 2010 is here for you',
                      :content_text => 'Our newsletter for Dec 2010 is here for you',
                      :from_email => 'support@mailtics.com',
                      :from_name => 'Mailtics Support',
                      :subject => 'Newsletter for the month of Dec 2010',
                      :published_at => Date.today


