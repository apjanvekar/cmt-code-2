class VersionhistoriesController < ApplicationController
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
    @versionhistory_pages, @versionhistories = paginate :versionhistories, :per_page => 10
  end

  def show
    @versionhistory = Versionhistory.find(params[:id])
  end

  def new
    @versionhistory = Versionhistory.new
  end

  def create
    @versionhistory = Versionhistory.new(params[:versionhistory])
    if @versionhistory.save
      flash[:notice] = 'Versionhistory was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @versionhistory = Versionhistory.find(params[:id])
  end

  def update
    @versionhistory = Versionhistory.find(params[:id])
    if @versionhistory.update_attributes(params[:versionhistory])
      flash[:notice] = 'Versionhistory was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Versionhistory.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
