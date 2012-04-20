class Carddetailsbkp < ActiveRecord::Migration
 def self.up
 create_table :carddetailsbkp do |t|
      t.column :bin, :string
      t.column :product, :string
      t.column :expiredate, :date
      t.column :priority, :string
      t.column :downloadeddate, :date
    end
  end

  def self.down
    drop_table :carddetailsbkp
  end
end
