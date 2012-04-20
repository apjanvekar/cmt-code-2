class CreateTokendisplays < ActiveRecord::Migration
  def self.up
    create_table :tokendisplays do |t|
        t.column :counterno, :int
      t.column :tokenno, :string
    end
  end

  def self.down
    drop_table :tokendisplays
  end
end
