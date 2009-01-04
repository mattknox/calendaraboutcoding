require "net/http"
require "lib/feed_me/lib/feed_me"

require "#{RAILS_ROOT}/vendor/plugins/calendar_helper/lib/calendar_helper.rb"
class User < ActiveRecord::Base
  has_many :projects
  has_many :checkins
  has_many :days

  before_create :set_github_login!
  after_create :pull_history

  def self.top_users
    User.find(:all)
  end
  
  def set_github_login!
    self.github_login = self.name
  end

  def streak
    Day.find(:first, :conditions => ["user_id = ? and date > ?", self.id, Date.today - 2.days ], :order => "date desc").current_streak rescue 0
  end

  def max_streak
    Day.maximum(:current_streak, :conditions => ["user_id = ?", self.id])
  end
  
  def pull_history
    # here, we should pull all of history, back to the most recent processed commit.
    unprocessed_checkins = []
    page = 1
    while 1 # go back until we get to github_current_to, or run out of history
      f = get_feed(page) 
      break unless f
      break if f.entries.blank? 
      page += 1
      earliest_time = Time.now
      f.entries.each do |e|
        url = e.url
        title = e.title
        content = e.content
        commit_time = e.updated_at.utc
        earliest_time = commit_time
        break if self.too_early?(earliest_time)
        if title.match(/committed to/) and !self.too_early?(commit_time)
          project_name = title.match(/[^\s]+ committed to [^\s]+\/([^\s]+)/)[1]
          project = Project.find_or_create_by_name_and_user_id(project_name, self.id)
          unprocessed_checkins <<  Checkin.new(:commit_time => commit_time,
                                               :content => content,
                                               :url => url,
                                               :project => project,
                                               :hashcode => url.split("/").last,
                                               :title => title,
                                               :user_id => self.id)
        end
      end
      break if self.too_early?(earliest_time)
    end
    # process all these unprocessed checkins
    unprocessed_checkins.sort { |x, y| x.commit_time <=> y.commit_time }.each do |u|
      u.save
      self.github_current_to = u.commit_time
    end
    self.save
  end

  def too_early?(time)
    self.github_current_to and (time <= self.github_current_to)
  end
  
  def on_days
    self.days.map { |d| d.date }
  end

  def did_today?
    self.on_days.include?(Date.today)
  end
  
  def get_feed(page = 1)
    s = Net::HTTP.get URI.parse("http://github.com/#{github_login}.atom?page=#{page}")
    FeedMe.parse(s)
  end
end
