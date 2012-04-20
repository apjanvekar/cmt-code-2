class DataFileAdimage < ActiveRecord::Base
  def self.save(upload)
    p "******************************"
    
    name =  upload['datafile'].original_filename
   puts name
   
    a=Dir.pwd()
                @path = Setting.find(:first)
                puts @path.Adverimagepath
                puts @path.Bank_ID
                @p = @path.Adverimagepath
                
                @path1 = @p.gsub('\\','/')
                
                #p @path1
                p File.directory?("#{@path1}")
                
                if File.directory?("#{@path1}")
                    FileUtils.mkdir_p "#{@path1}/#{@path.Bank_ID}_images"
                    e="#{@path1}/#{@path.Bank_ID}_images"
                    Dir.chdir(e)
                   
                    Dir.chdir(a)
                    puts "in if"
                else
                    FileUtils.mkdir_p "#{@path1}/#{@path.Bank_ID}_images"
                    e="#{@path1}/#{@path.Bank_ID}_images"
                    Dir.chdir(e)
                    FileUtils.mkdir_p "#{@path1}/#{@path.Bank_ID}_images"
                    f="#{@path1}/#{@path.Bank_ID}_images"
                    Dir.chdir(f)
                   
                    Dir.chdir(a)
                    puts "in else"
                end
   
   
   directory = "#{@path1}/#{@path.Bank_ID}_images"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end

end
