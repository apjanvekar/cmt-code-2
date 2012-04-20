class ScrollmsgsController < ApplicationController
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
    @scrollmsg_pages, @scrollmsgs = paginate :scrollmsgs, :per_page => 10
  end

  def show
    @scrollmsg = Scrollmsg.find(params[:id])
  end

  def new
    @scrollmsg = Scrollmsg.new
  end

  def create
    @scrollmsg = Scrollmsg.new(params[:scrollmsg])
    if @scrollmsg.save
      flash[:notice] = 'Scrollmsg was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @scrollmsg = Scrollmsg.find(params[:id])
  end

  def update
     puts "in updtae"
    @scrollmsg = Scrollmsg.find(params[:id])
    if @scrollmsg.update_attributes(params[:scrollmsg])
      flash[:notice] = 'Scrollmsg was successfully updated.'
      puts params[:id]
      puts params[:scrollmsg][:status]
      @findstatus=Scrollmsg.find(:all,:conditions=>["id<>? and status=?",params[:id],params[:scrollmsg][:status]])
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

  def destroy
    Scrollmsg.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def back
render :update do |page|

page.redirect_to url_for(:controller=>'scrollmsgs', :action=>'list')
end
end 
end
