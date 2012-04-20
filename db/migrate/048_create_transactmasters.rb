class CreateTransactmasters < ActiveRecord::Migration
  def self.up
    create_table :transactmasters do |t|
    end
  end

  def self.down
    drop_table :transactmasters
  end
end
