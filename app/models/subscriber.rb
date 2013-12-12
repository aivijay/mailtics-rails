class Subscriber < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 20

  validates :email, :presence => true

  belongs_to :user
  has_and_belongs_to_many :contacts

  def title
    "#{email} - #{first_name} #{last_name}"
  end

  def owned_by?(owner)
    return false unless owner.is_a? User
    user == owner
  end

  def status_image 
    simages = {"0" => "/images/s4.png", "1" => "/images/s1.png", "2" => "/images/s2.png", "3" => "/images/s3.png"}

    return '<img src="' + simages[status.to_s] + '" height="20" />'
  end
end
