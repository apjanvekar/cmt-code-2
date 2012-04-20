class Displayscrollmsgsbkp < ActiveRecord::Migration
   def self.up
  create_table :displayscrollmsgsbkp do |t|
     t.column :scrollmsg, :string
       t.column :downloadeddate, :date
    end
  end

  def self.down
    drop_table :Ddsplayscrollmsgsbkp
  end
end
