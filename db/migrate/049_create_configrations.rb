class CreateConfigrations < ActiveRecord::Migration
   def self.up
    create_table :configrations do |t|
      t.column :serverip, :string
      t.column :KioskIp, :string
      t.column :aplabserver, :string
      
      
    end
  end

  def self.down
    drop_table :configrations
  end
end
