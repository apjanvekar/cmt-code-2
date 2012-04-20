class CreateTransacts < ActiveRecord::Migration
  def self.up
    create_table :transacts do |t|
      t.column :tokenno,:string
      t.column :tokenid, :int
      t.column :ctypeid, :string
      t.column :transdate, :date
      t.column :generatedtime, :time
      t.column :serviceid, :string
      t.column :counterno, :int     
      t.column :accno, :string
      t.column :login, :string
     t.column :calledtime, :time
    t.column :servicedtime, :time
    t.column :timetaken, :time
    t.column :waittime, :time
    t.column :stpname, :string
    t.column :nonstpname, :string
    t.column :tokenstatus, :char
    
     t.column :pauseflag, :int
      t.column :pausetime, :time
      t.column :releasetime, :time
      t.column :bulkcount, :int
	t.column :call1, :time
t.column :reasons, :string	
t.column :missingflag, :int
	t.column :pullcounter, :int
	t.column :redirecttime, :time
        
      
    end
  end

  def self.down
    drop_table :transacts
  end
end
