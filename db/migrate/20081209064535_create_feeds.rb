class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.integer :user_id
      t.integer :feed_spec_id
      t.string :login
      t.string :password

      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
