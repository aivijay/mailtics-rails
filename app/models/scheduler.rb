class Scheduler < ActiveRecord::Base
  validates :campaign_id, :presence => true

  # relationships
  #has_many :campaigns, :dependent => :destroy
  belongs_to :user

  def created_user 
    return "#{user.profile.last_name}, #{user.profile.first_name}"
  end

  def status_string
    sv = {'0' => 'scheduled', '1' => 'processing', '2' => 'completed', '-1' => 'error'}
    return sv[status.to_s]
  end

  def campaign_name
    return Campaign.find(campaign_id).name
  end

end
