class Nonstpsbkp < ActiveRecord::Migration
  def self.up
   create_table :nonstpsbkp do |t|
        t.column :nonstpname, :string
          t.column :status, :char
           t.column :downloadeddate, :date
            t.column :created_on, :date
            t.column :updated_on, :date
    end
  end

  def self.down
    drop_table :nonstpsbkp
  end
end
