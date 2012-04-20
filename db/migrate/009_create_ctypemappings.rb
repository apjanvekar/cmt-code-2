class CreateCtypemappings < ActiveRecord::Migration
  def self.up
    create_table :ctypemappings do |t|
      t.column :counterno, :int
      t.column :ctypeid, :string
    end
  end

  def self.down
    drop_table :ctypemappings
  end
end
