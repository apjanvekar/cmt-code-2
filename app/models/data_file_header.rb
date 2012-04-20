class DataFileHeader < ActiveRecord::Base
  def self.save(upload)
    name =  "header.gif"
    directory = "/root/"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafileheader'].read) }
  end
end
