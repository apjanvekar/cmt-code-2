class CreateVersionhistories < ActiveRecord::Migration
  def self.up
    create_table :versionhistories do |t|
      t.column :javafd, :string
      t.column :javatd, :string
      t.column :rubyonrails, :string
    end
  end

  def self.down
    drop_table :versionhistories
  end
end
