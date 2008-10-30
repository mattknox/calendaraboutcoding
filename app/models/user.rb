class User < ActiveRecord::Base

  def seinfeld
    now        = Date.new(params[:year], params[:month])
    prev_month = now << 1
    next_month = now >> 1
    calendar :year => now.year, :month => now.month,
    :previous_month_text => %(<a href="/~#{self.login}/#{prev_month.year}/#{prev_month.month}">Previous Month</a>), 
    :next_month_text     => %(<a href="/~#{self.login}/#{next_month.year}/#{next_month.month}" class="next">Next Month</a>) do |d|
#      if @progressions.include? d
#        [d.mday, {:class => "progressed"}]
#      else
#        [d.mday, {:class => "slacked"}]
#      end
    end
  end
end
