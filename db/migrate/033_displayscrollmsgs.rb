class Displayscrollmsgs < ActiveRecord::Migration
  def self.up
    create_table :displayscrollmsgs do |t|
    t.column :scrollmsg, :string
    t.column :status, :integer, :default=>"0"
    end
  end

  def self.down
    drop_table :displayscrollmsgs
  end
end
