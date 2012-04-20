class CreateAuxreasons < ActiveRecord::Migration
  def self.up
    create_table :auxreasons do |t|
      t.column :auxcode, :int
      t.column :reasons, :string
    end
  end

  def self.down
    drop_table :auxreasons
  end
end
