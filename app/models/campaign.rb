class Campaign < ActiveRecord::Base
  validates :name, :presence => true
  #validates :subject, :presence => true
  #validates :content_text, :presence => true
  validates :from_name, :presence => true
  validates :from_email, :presence => true

  # relationship
  belongs_to :user
  ##belongs_to :scheduler
  has_and_belongs_to_many :categories
  #belongs_to :cateogry  
  has_many :comments

  scope :published, where("campaigns.published_at IS NOT NULL")
  scope :draft, where("campaigns.published_at is NULL")
  scope :active, where("campaigns.status = 1").order("campaigns.name") 
  scope :recent, lambda { published.where("articles.published_at > ?", 1.week.ago.to_date)}
  scope :where_name, lambda { |term| where("campaigns.name LIKE ?", "%#{term}%")}
  scope :where_subject, lambda { |term| where("campaigns.subject LIKE ?", "%#{term}%")}

  #after_create :email_campaign_author

  def title
    "#{name} - #{published_at}"
  end

  def published?
    published_at.present?
  end

  #def email_campaign_author
  #  puts "We will notify #{campaign.user.email} through email"
  #end

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
