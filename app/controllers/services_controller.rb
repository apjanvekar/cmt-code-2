#An unpublished work of Sprylogic Technologies Ltd. 
# © Copyright Sprylogic Technologies Ltd. 2008. All rights reserved 
# version DQMS_ROR_ver1.0.2 
class ServicesController < ApplicationController
  layout 'accounts'
  before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @service_pages, @services = paginate :services, :per_page => 10
  end

  def show
    @service = Service.find(params[:id])
  end

  def new
    @service = Service.new
  end
def new_services
    
		  "serviceid #{[params[:service][:serviceid]]}"
     @new=Service.find_first(["serviceid=?",params[:service][:serviceid]])
     
     
     
    if @new!=nil	
    @new.servicestatus=1
    @new.save
    
    #@s=Service.update_all(@new.id,{:servicestatus=>'1'})
   
 end
 
  render :update do |page|
     page.replace_html('services', :partial =>'newservice')
       #page.replace_html('oldservices', :partial =>'oldservice')
       page.replace_html('replace', :partial =>'replace')
      end
    #else
     #render :update do |page| 
		#page.alert "This Service is Already Assigned to Counter No.""#{params[:counter][:counterno] }"
		#end 
		#end 
#end

end

def remove_services
    
		  "serviceid #{[params[:newservice][:serviceid]]}"
     @remove=Service.find_first(["serviceid=?",params[:newservice][:serviceid]])
      "#{@remove.serviceid}"
  
     
    if @remove!=nil	
      if @remove.serviceflag==1
        render :update do |page|
           page.alert 'You cannot delete this service'
        end
      else
      @remove.servicestatus=0
    @remove.save
        
render :update do |page|
      page.replace_html('services', :partial =>'newservice')
       #page.replace_html('oldservices', :partial =>'oldservice')
       page.replace_html('replace', :partial =>'replace')
      end
     end
   end
    
    #else
     #render :update do |page| 
		#page.alert "This Service is Already Assigned to Counter No.""#{params[:counter][:counterno] }"
		#end 
		#end 
#end

end



def all_services
  
      @all= Service.find_all(["servicestatus=0"])
      @all.each do |d|
         "#{d.serviceid}"
        d.servicestatus="1"
        d.save
      end
render :update do |page|
      page.replace_html('services', :partial =>'newservice')
       #page.replace_html('oldservices', :partial =>'oldservice')
       page.replace_html('replace', :partial =>'replace')
      end

end

def remove_all
   @r= Service.find_all(["serviceflag=0 and servicestatus=1"])
      @r.each do |d|
        
         "#{d.serviceid}"
        d.servicestatus="0"
        d.save
      end
  render :update do |page|
      page.replace_html('services', :partial =>'newservice')
       #page.replace_html('oldservices', :partial =>'oldservice')
       page.replace_html('replace', :partial =>'replace')
      end
end
  def create
    @service = Service.new(params[:service])
    if @service.save
      flash[:notice] = 'Service was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @service = Service.find(params[:id])
  end

  def update
    @service = Service.find(params[:id])
     @start_time = params[:service][:"starttime(4i)"].to_i*3600+params[:service][:"starttime(5i)"].to_i*60+params[:service][:"starttime(6i)"].to_i
    @end_time = params[:service][:"endtime(4i)"].to_i*3600+params[:service][:"endtime(5i)"].to_i*60+params[:service][:"endtime(6i)"].to_i
    if @start_time<@end_time
       if @service.update_attributes(params[:service])
          flash[:notice] = fading_flash_message("Service was successfully updated.", 5)
          redirect_to :action => 'list'
       else
          render :action => 'edit'
      end

    else
        @msg="Please select end time greater than start time."
        render :action => 'edit'
    end
  end

  def destroy
    Service.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
 def stp
 end
 
  def list_stp
     @stp_pages, @stps = paginate :stps, :per_page => 10
  end
 
 def back_stp
     render :update do |page|
     page.redirect_to url_for(:controller=>'services', :action=>'list')
     end
  end
 def back
     render :update do |page|
     page.redirect_to url_for(:controller=>'services', :action=>'list')
     end
  end
 
 def create_stp
     @stp = Stp.new(params[:stp])
     if @stp.save
       flash[:notice] = 'STP Service was successfully created.'
       redirect_to :action => 'list_stp'
     else
       render :action => 'new_stp'
     end
  end
  
  def new_stp
      @stp = Stp.new
  end
  
   def edit_stp
      @stp = Stp.find(params[:id])
    end
  
    def update_stp
      @stp = Stp.find(params[:id])
      if @stp.update_attributes(params[:stp])
        flash[:notice] = 'STP Service was successfully updated.'
        redirect_to :action => 'list_stp'
      else
        render :action => 'edit_stp'
      end
    end
  
    def destroy_stp
      Stp.find(params[:id]).destroy
      redirect_to :action => 'list_stp'
  end
  
  
  def nstp
  end
   
    def list_nstp
       @nonstp_pages, @nonstps = paginate :nonstps, :per_page => 10
    end
   
   def create_nstp
       @nonstp = Nonstp.new(params[:nonstp])
       if @nonstp.save
         flash[:notice] = 'STP Service was successfully created.'
         redirect_to :action => 'list_nstp'
       else
         render :action => 'new_nstp'
       end
    end
    
    def new_nstp
        @nonstp = Nonstp.new
    end
    
     def edit_nstp
        @nonstp = Nonstp.find(params[:id])
      end
    
      def update_nstp
        @nonstp = Nonstp.find(params[:id])
        if @nonstp.update_attributes(params[:nonstp])
          flash[:notice] = 'Non STP Service was successfully updated.'
          redirect_to :action => 'list_nstp'
        else
          render :action => 'edit_nstp'
        end
      end
    
      def destroy_nstp
        Nonstp.find(params[:id]).destroy
        redirect_to :action => 'list_nstp'
  end
end
