class AddTime < ActiveRecord::Migration
  def self.up
    #add_column :services, :sid, :string
    add_column :services, :starttime, :time
    add_column :services, :endtime, :time
    
    
  end

  def self.down
  end
end
