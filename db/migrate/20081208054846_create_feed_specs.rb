class CreateFeedSpecs < ActiveRecord::Migration
  def self.up
    create_table :feed_specs do |t|
      t.string :uri
      t.string :regex
      t.string :time_field_name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :feed_specs
  end
end
