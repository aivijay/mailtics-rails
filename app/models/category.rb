class Category < ActiveRecord::Base
  # relationships
  has_and_belongs_to_many :campaigns
  #has_many :campaigns

  default_scope order('categories.name')
end
