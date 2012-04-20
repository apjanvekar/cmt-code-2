class CreateNonstps < ActiveRecord::Migration
  def self.up
    create_table :nonstps do |t|
        t.column :nonstpname, :string
          t.column :status, :char
            t.column :created_on, :date
            t.column :updated_on, :date
    end
  end

  def self.down
    drop_table :nonstps
  end
end
