class Checkin < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  after_create :update_day!
  
  def update_day!
    d = Day.find_or_initialize_by_date_and_user_id(self.commit_time.to_date, self.user_id)
    prev_streak = Day.find_by_date_and_user_id(self.commit_time.to_date - 1.day, self.user_id).current_streak rescue 0
    d.commit_count = d.commit_count.to_i.succ
    d.current_streak = prev_streak.succ
    d.save
  end
end
