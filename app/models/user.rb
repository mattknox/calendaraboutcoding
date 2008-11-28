require "#{RAILS_ROOT}/vendor/plugins/calendar_helper/lib/calendar_helper.rb"
class User < ActiveRecord::Base
  has_many :projects
  has_many :checkins
  has_many :days

  after_create :pull_all_history

  def pull_history
    # here, we should pull all of history, back as far as one's most recent commits
  end
  
  def on_days
    self.days.map { |d| d.date }
  end
end

# this is sufficient to grab the feed from github for a user.  
# require "net/http"
# require "lib/feed_me/lib/feed_me"

# s = Net::HTTP.get URI.parse('http://github.com/mattknox.atom')
# FeedMe.parse(s)
