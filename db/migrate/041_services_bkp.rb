class ServicesBkp < ActiveRecord::Migration
  def self.up
  create_table :servicesbkp do |t|
    t.column :serviceid, :string
    t.column :servicename, :string
    t.column :thresholdtime, :time
    t.column :servicestatus, :char
    t.column :buttonno, :int
    t.column :priority, :int
     t.column :downloadeddate, :date
    t.column :created_on,:date
    t.column :updated_on, :date
    t.column :serviceflag, :int
    t.column :sid, :string
      t.column :starttime, :time
        t.column :endtime, :time
    end
  end

  def self.down
    drop_table :servicesbkp
  end
end
