class Adsbkp < ActiveRecord::Migration
  def self.up
    create_table :adsbkp do |t|
     t.column :adtext, :string
     t.column :downloadeddate, :date
    end
  end

  def self.down
    drop_table :adsbkp
  end
end
