class Customertypesbkp < ActiveRecord::Migration
  def self.up
    create_table :customertypesbkp do |t|
        t.column :ctypeid, :string
          t.column :ctypedesc, :string
            t.column :priority, :int
            t.column :thresholdtime, :time
             t.column :downloadeddate, :date
    end
  end

  def self.down
    drop_table :customertypesbkp
  end
end
