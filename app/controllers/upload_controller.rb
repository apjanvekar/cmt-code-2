class UploadController < ApplicationController
  layout 'accounts'
before_filter :login_required

  def index
     #render :file => 'app\views\upload\uploadfile.rhtml'
   end
   
   
   
  def uploadFile
    p " in upload"
    begin
    puts "333333333333 #{params[:upload]}"
    post = DataFile.save(params[:upload])
    rescue 
      flash[:notice] = "Please Select An Image File For Upload"
  end
  flash[:notice] = "File has been uploaded successfully"
   redirect_to :action=>'uploadfile'
   end

def uploadFile1
    p " in upload1"
    
    begin
    post = DataFileHeader.save(params[:upload])
    rescue 
      flash[:notice] = "Please Select An Image File For Upload"
  end
  
    
   redirect_to :action=>'uploadfileheader'
   end


def uploadFile2
    p " in upload2"
    
    begin
    post = DataFilePrinter.save(params[:upload])
    rescue 
      flash[:notice] = "Please Select An Image File For Upload"
  end
    
   redirect_to :action=>'uploadfileprinter'
 end
 
 def uploadFile3
 p "----------- - ------------------"
 
 if  params[:upload]!=nil
     begin
          post = DataFileAdimage.save( params[:upload])
     rescue Exception => ex
          puts ex.message
     end
          #render :text => "File has been uploaded successfully"
          flash[:notice] = "File has been uploaded successfully"
          redirect_to :action => 'advertiseimage'
     else
          #render :text => "Please select file 4 upload"
          flash[:notice] = "Please select file for upload"
          redirect_to :action => 'advertiseimage'
    end
    
  end
 
 
# post = DataFileAdimages.save(params[:upload])
 #redirect_to :action=>'advertiseimage'
 
 #end
 
end
