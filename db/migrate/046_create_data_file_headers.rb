class CreateDataFileHeaders < ActiveRecord::Migration
  def self.up
    create_table :data_file_headers do |t|
    end
  end

  def self.down
    drop_table :data_file_headers
  end
end
