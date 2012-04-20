class CreateAds < ActiveRecord::Migration
  def self.up
    create_table :ads do |t|
     t.column :adtext, :string
    end
  end

  def self.down
    drop_table :ads
  end
end
