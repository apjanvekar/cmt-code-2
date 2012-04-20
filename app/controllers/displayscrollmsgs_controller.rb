class DisplayscrollmsgsController < ApplicationController
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
    @displayscrollmsg_pages, @displayscrollmsgs = paginate :displayscrollmsgs, :per_page => 10
  end

  def show
    @displayscrollmsg = Displayscrollmsg.find(params[:id])
  end

  def new
    @displayscrollmsg = Displayscrollmsg.new
  end

  def create
     puts  params[:scrollmsg]
     @displayscrollmsg = Displayscrollmsg.new(params[:scrollmsg])
    if @displayscrollmsg.save
      flash[:notice] = fading_flash_message("Scrollmessage created sucessfully", 5)
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @displayscrollmsg = Displayscrollmsg.find(params[:id])
  end

  def update
     puts "in updtae"
      puts "-------------------"
     p params[:displayscrollmsg][:status]
      puts "-------------------"
    @displayscrollmsg = Displayscrollmsg.find(params[:id])
    if @displayscrollmsg.update_attributes(params[:displayscrollmsg])
      flash[:notice] = fading_flash_message("Scrollmessage was successfully updated.", 5)
      puts params[:id]
      puts params[:displayscrollmsg][:status]
      @findstatus=Displayscrollmsg.find(:all,:conditions=>["id<>? and status=?",params[:id],params[:displayscrollmsg][:status]])
      @findstatus.each do |d|
      
      d.status=0
      d.save    
      puts "data saved"
      end
       
      #redirect_to :action => 'show', :id => @scrollmsg
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy_scroll
    p"111111111111111"
    p params[:id]
    p"111111111111111"
    Displayscrollmsg.find(params[:id]).destroy
    flash[:notice] = fading_flash_message("Scrollmessage was deleted successfully", 5)
    redirect_to :action => 'list'
  end
  
  def back1
render :update do |page|

page.redirect_to url_for(:controller=>'displayscrollmsgs', :action=>'list')
end
end 
end
