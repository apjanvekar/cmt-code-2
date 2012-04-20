class Auxreasonsbkp < ActiveRecord::Migration
  def self.up
   create_table :auxreasonsbkp do |t|
      t.column :auxcode, :int
      t.column :reasons, :string
       t.column :downloadeddate, :date
    end
  end

  def self.down
    drop_table :auxreasonsbkp
  end
end

