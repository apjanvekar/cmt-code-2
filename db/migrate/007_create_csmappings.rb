class CreateCsmappings < ActiveRecord::Migration
  def self.up
    create_table :csmappings do |t|
        t.column :counterno, :int
          t.column :serviceid, :string
    end
  end

  def self.down
    drop_table :csmappings
  end
end
