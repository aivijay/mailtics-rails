class Comment < ActiveRecord::Base
  belongs_to :campaign
  validates :name, :presence => true
  validates :body, :presence => true

end
