class Feed < ActiveRecord::Base
  belongs_to :feed_spec
  belongs_to :user
end
