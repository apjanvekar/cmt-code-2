class Addtransactdata < ActiveRecord::Migration
  def self.up
    add_column :transacts, :exported, :string, :default=>"FALSE"
    add_column :transactmaster, :exported, :string, :default=>"FALSE"
    add_column :ads, :status, :integer, :default=>"0"
  end

  def self.down
  end
end
