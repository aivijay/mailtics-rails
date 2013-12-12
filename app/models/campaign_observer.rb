class CampaignObserver < ActiveRecord::Observer
  def after_create(comment)
    puts " We will notify the author through email"
  end
end
