class CreateCustomertypes < ActiveRecord::Migration
  def self.up
    create_table :customertypes do |t|
        t.column :ctypeid, :string
          t.column :ctypedesc, :string
            t.column :priority, :int
	t.column :thresholdtime, :time	
    end
  end

  def self.down
    drop_table :customertypes
  end
end
