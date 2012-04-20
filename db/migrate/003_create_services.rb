class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
    t.column :serviceid, :string
    t.column :servicename, :string
    t.column :thresholdtime, :time
    t.column :servicestatus, :char
    t.column :buttonno, :int
    t.column :priority, :int
    t.column :created_on,:date
    t.column :updated_on, :date
    end
  end

  def self.down
    drop_table :services
  end
end
