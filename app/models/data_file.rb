class DataFile < ActiveRecord::Base
  
   def self.save(upload)
    
    name = "logo.gif"
    directory = "public/stylesheets/images"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end

end
