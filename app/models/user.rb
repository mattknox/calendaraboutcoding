require "net/http"
require "lib/feed_me/lib/feed_me"

require "#{RAILS_ROOT}/vendor/plugins/calendar_helper/lib/calendar_helper.rb"
class User < ActiveRecord::Base
  has_many :projects
  has_many :checkins
  has_many :days

  after_create :pull_history

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
        commit_time = e.updated_at
        earliest_time = commit_time
        break if self.too_early?(earliest_time)
        if title.match(/committed to/) and !self.too_early?(commit_time)
          unprocessed_checkins <<  Checkin.new(:commit_time => commit_time,
                                               :content => content,
                                               :url => url,
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

  # tore this out of CAN, should rework it, so that it grabs as far back as it needs to to get all your history
  # or all your history back to the last pull
  def committed_days_in_feed(page = 1)
    Time.zone     = time_zone || "UTC"
    feed          = get_feed(page)
    return nil if feed.nil?
    entry_id      = nil # track the first entry id to store in the user model
    skipped_early = nil
    return nil if feed.entries.empty?
    days = feed.entries.inject({}) do |selected, entry|
      this_entry_id = entry.item_id
      entry_id    ||= this_entry_id
      if last_entry_id == this_entry_id
        skipped_early = true
        break selected
      end
      
      if entry.title.downcase =~ %r{^#{login.downcase} committed}
        updated = entry.updated_at.in_time_zone
        date    = Date.civil(updated.year, updated.month, updated.day)
        selected.update date => nil
      else
        selected
      end
    end.keys
    if page == 1
      self.last_entry_id = entry_id 
      unless skipped_early
        while paged_days = committed_days_in_feed(page += 1)
          days += paged_days
        end
        days.uniq!
      end
    end
    days
  end

  def get_feed(page = 1)
    s = Net::HTTP.get URI.parse("http://github.com/#{github_login}.atom?page=#{page}")
    FeedMe.parse(s)
  end
end
