class SettingsController < ApplicationController
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
    @setting_pages, @settings = paginate :settings, :per_page => 10
  end
  def hhlist
    @setting_pages, @settings = paginate :settings, :per_page => 10
  end
  def Branchid
    @setting_pages, @settings = paginate :settings, :per_page => 10
  end
  def show
    @setting = Setting.find(params[:id])
  end

  def new
    @setting = Setting.new
  end

  def create
    @setting = Setting.new(params[:setting])
    if @setting.save
      flash[:notice] = 'Setting was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @setting = Setting.find(params[:id])
  end
   def hhedit
    @setting = Setting.find(params[:id])
  end
def editb
    @setting = Setting.find(params[:id])
  end
  def update
    @setting = Setting.find(params[:id])
     if @setting.update_attributes(params[:setting])
      flash[:notice] = fading_flash_message("settings updated Sucessfully. ", 3) 
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end
  def hhupdate
    @setting = Setting.find(params[:id])
 
    if @setting.update_attributes(params[:setting])
      
      
      redirect_to :action => 'hhlist'
    else
      render :action => 'hhedit'
    end
  end
def updateb
    @setting = Setting.find(params[:id])
  
    if @setting.update_attributes(params[:setting])
        
      
      redirect_to :action => 'Branchid'
    else
      render :action => 'edit'
    end
  end
  def destroy
    Setting.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  
def back
#Csmapping.delete_all(["counterno = ? ",params[:counter][:counterno]]) 
render :update do |page|

page.redirect_to url_for(:controller=>'settings', :action=>'list')
end
end 
def hhback
#Csmapping.delete_all(["counterno = ? ",params[:counter][:counterno]]) 
render :update do |page|

page.redirect_to url_for(:controller=>'settings', :action=>'hhlist')
end
end 
def backb
#Csmapping.delete_all(["counterno = ? ",params[:counter][:counterno]]) 
render :update do |page|

page.redirect_to url_for(:controller=>'settings', :action=>'Branchid')
end
end 
end
