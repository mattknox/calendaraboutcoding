class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :github_login
      t.datetime :github_current_to

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
