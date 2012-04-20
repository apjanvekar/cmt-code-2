class CreateCustomerdetails < ActiveRecord::Migration
  def self.up
    create_table :customerdetails do |t|
      t.column :custid, :string
      t.column :custname, :string
      t.column :cardno, :string
      t.column :customertype, :string
    end
  end

  def self.down
    drop_table :customerdetails
  end
end
