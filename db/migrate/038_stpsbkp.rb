class Stpsbkp < ActiveRecord::Migration
  def self.up
   create_table :stpsbkp do |t|
    t.column :stpname, :string
    t.column :servicetime, :time
    t.column :status, :char
     t.column :downloadeddate, :date
    t.column :created_on, :date
    t.column :serviceid, :string
    t.column :updated_on, :date
    end
  end

  def self.down
    drop_table :stpsbkp
  end
end
