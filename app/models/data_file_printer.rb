class DataFilePrinter < ActiveRecord::Base
  def self.save(upload)
    
    name = "logo.jpg"
    directory = "/home/ssp"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafileprinter'].read) }
  end
end
