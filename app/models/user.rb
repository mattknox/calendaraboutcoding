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

  # this is sufficient to grab the feed from github for a user.  
  # require "net/http"
  # require "lib/feed_me/lib/feed_me"
  
  # s = Net::HTTP.get URI.parse('http://github.com/mattknox.atom')
  # FeedMe.parse(s)
  
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

  private
  def get_feed(page = 1)
    s = Net::HTTP.get URI.parse("http://github.com/#{github_login}.atom?page=#{page}")
    FeedMe.parse(s)
  end
end
