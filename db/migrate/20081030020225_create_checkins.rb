class CreateCheckins < ActiveRecord::Migration
  def self.up
    create_table :checkins do |t|
      t.references :user
      t.references :project
      t.datetime :commit_time
      t.string :comment
      t.string :hashcode
      t.string :title
      t.string :url
      t.text :content
      t.string 

      t.timestamps
    end
  end

  def self.down
    drop_table :checkins
  end
end
