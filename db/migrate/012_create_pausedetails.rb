class CreatePausedetails < ActiveRecord::Migration
  def self.up
    create_table :pausedetails do |t|
      t.column :counterno, :int
      t.column :login, :string
      t.column :pdate, :date
      t.column :stime, :time
      t.column :etime, :time
      t.column :reason, :string
      t.column :pflag, :char
      
    end
  end

  def self.down
    drop_table :pausedetails
  end
end
