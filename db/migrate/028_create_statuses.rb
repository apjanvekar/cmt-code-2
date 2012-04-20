class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.column :branchname, :string
      t.column :totaltokenserved, :int
      t.column :pendingtokencount, :int
      t.column :noofactivecounters, :int
      t.column :goldcount, :int
      t.column :customercount, :int
      t.column :noncustomercount, :int
      t.column :printerstatus, :string
      t.column :dqmstatus, :string
    end
  end

  def self.down
    drop_table :statuses
  end
end
