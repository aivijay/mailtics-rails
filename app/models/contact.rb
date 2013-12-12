class Contact < ActiveRecord::Base
  validates :name, :presence => true

  scope :active, where("contacts.status = 1").order("contacts.name")

  # relationships
  belongs_to :user
  has_and_belongs_to_many :subscribers

  def owned_by?(owner)
    return false unless owner.is_a? User
    user == owner
  end

  # get the user name who created this Contacts list
  def created_user 
    return "#{user.profile.last_name}, #{user.profile.first_name}"
  end

  def status_string
    sv = {"0" => "Inactive", "1" => "Active", "-1" => "Deleted"}
    return sv[status.to_s]
  end

end
