class Settings < ActiveRecord::Migration
  def self.up
 create_table :settings do |t|
      
      t.column :missingcount, :int
      t.column :missingtime, :time
      
      t.column :returntime, :string
      
      t.column :branchname, :string
      t.column :paperstatus, :string,:default=>"TRUE"
    end
   Setting.create(:missingcount => '2',
  :missingtime => '00:02:00',
  :returntime => '10',
  :branchname => 'ICICI BANK'
  )
  end

  def self.down
    drop_table :settings
  end
end

