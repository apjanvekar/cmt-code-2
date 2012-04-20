class CreateCounters < ActiveRecord::Migration
  def self.up
    create_table :counters do |t|
    t.column :counterno, :int
    t.column :loginstatus, :char, :default=>'N'
    t.column :counterstatus, :char
    end
  end

  def self.down
    drop_table :counters
  end
end
