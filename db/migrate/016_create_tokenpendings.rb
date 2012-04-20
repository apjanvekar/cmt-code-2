class CreateTokenpendings < ActiveRecord::Migration
  def self.up
    create_table :tokenpendings do |t|
       t.column :tokenno,:string
      t.column :tokenid, :int
      t.column :ctypeid, :string
      t.column :transdate, :date
      t.column :generatedtime, :time
      t.column :serviceid, :string
      t.column :counterno, :int   
      t.column :tokenstatus, :char      
    end
  end

  def self.down
    drop_table :tokenpendings
  end
end
