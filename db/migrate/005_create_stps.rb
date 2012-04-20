class CreateStps < ActiveRecord::Migration
  def self.up
    create_table :stps do |t|
    t.column :stpname, :string
    t.column :servicetime, :time
    t.column :status, :char
    t.column :created_on, :date
    t.column :serviceid, :string
    t.column :updated_on, :date
    end
  end

  def self.down
    drop_table :stps
  end
end
