class CreateDataFilePrinters < ActiveRecord::Migration
  def self.up
    create_table :data_file_printers do |t|
    end
  end

  def self.down
    drop_table :data_file_printers
  end
end
