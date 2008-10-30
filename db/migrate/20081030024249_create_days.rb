class CreateDays < ActiveRecord::Migration
  def self.up
    create_table :days do |t|
      t.integer :user_id
      t.date :date
      t.integer :commit_count

      t.timestamps
    end
  end

  def self.down
    drop_table :days
  end
end
