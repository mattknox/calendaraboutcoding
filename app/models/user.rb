require "#{RAILS_ROOT}/vendor/plugins/calendar_helper/lib/calendar_helper.rb"
class User < ActiveRecord::Base
  has_many :projects
  has_many :checkins
  has_many :days

  def on_days
    (17..29).map { |i| Date.today.beginning_of_month + i.days }
  end
  
  def seinfeld
    now        = Date.new(2008, 10 )
    prev_month = now << 1
    next_month = now >> 1
    calendar :year => now.year, :month => now.month,
    :previous_month_text => %(<a href="/~#{self.name}/#{prev_month.year}/#{prev_month.month}">Previous Month</a>), 
    :next_month_text     => %(<a href="/~#{self.name}/#{next_month.year}/#{next_month.month}" class="next">Next Month</a>) do |d|
      logger.info d.inspect
      if self.on_days.include? d
        [d.mday, {:class => "progressed"}]
      else
        [d.mday, {:class => "slacked"}]
      end
    end
  end
end
