class Profile < ActiveRecord::Base
  belongs_to :user

  def name 
    return "#{last_name}, #{first_name}"
  end 
end
