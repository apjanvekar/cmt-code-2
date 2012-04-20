class CreateUsmappings < ActiveRecord::Migration
  def self.up
    create_table :usmappings do |t|
      t.column :login, :string
      t.column :serviceid,:string
    end
  end

  def self.down
    drop_table :usmappings
  end
end
