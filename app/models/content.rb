class Content < ActiveRecord::Base
  validates :name, :presence => true
  validates :content_text, :presence => true

  scope :published, where("campaigns.published_at IS NOT NULL")
  scope :draft, where("campaigns.published_at is NULL")
  scope :active, where("contents.status = 1").order("contents.name")

  belongs_to :user

  def owned_by?(owner)
    return false unless owner.is_a? User
    user == owner
  end

  def created_user 
    return "#{user.profile.last_name}, #{user.profile.first_name}"
  end

  def status_string
    sv = {"0" => "Inactive", "1" => "Active", "-1" => "Deleted"}
    return sv[status.to_s]
  end
end
