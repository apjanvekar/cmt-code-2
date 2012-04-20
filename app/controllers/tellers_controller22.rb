#An unpublished work of Sprylogic Technologies Ltd. 
# © Copyright Sprylogic Technologies Ltd. 2008. All rights reserved 

class TellersController < ApplicationController
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
    @counter_pages, @counters = paginate :counters, :per_page => 10
    @session['counter']=0
    @session['editcounter']=0
  end

  def show
    @counter = Counter.find(params[:id])
  end

  def new
    @counter = Counter.new
   
  end

def create
  p "#{params[:type1]}"
  
    
   
  @type=Csmapping.find_first(["counterno=?",params[:counter][:counterno]])
  @ctype=Ctypemapping.find_first(["counterno=?",params[:counter][:counterno]])
  
     @counter=Counter.find_first(["counterno=?",params[:counter][:counterno]])
    if(@counter!=nil)
      render :update do |page|   
    page.alert "CounterNo already exists"
    end
    elsif(@type==nil and params[:type1]==nil and params[:type2]==nil and params[:type3]==nil)
    render :update do |page|
       page.alert "Please select customer type and service"
     end
    elsif(@type==nil)
     
       render :update do |page|
       page.alert "Please select atleast one Service"
     end
     
     elsif(params[:type1]==nil and params[:type2]==nil and params[:type3]==nil)
      
       render :update do |page|
       page.alert "Please select atleast one Customer"
     end
     else
        
      @map=Counter.new
      @map.counterno=params[:counter][:counterno]
      #@map.loginstatus=params[:counter][:loginstatus]
      @map.counterstatus=params[:counter][:counterstatus]
      @map.save
        
      if (params[:type1]=='1')
      @map=Ctypemapping.new
      @map.counterno=params[:counter][:counterno]
      @map.ctypeid=1
      @map.save
      end
       if (params[:type2]=='2')
      @map=Ctypemapping.new
      @map.counterno=params[:counter][:counterno]
      @map.ctypeid=2
      @map.save
    end
     if (params[:type3]=='3')
      @map=Ctypemapping.new
      @map.counterno=params[:counter][:counterno]
      @map.ctypeid=3
      @map.save
    end
    
    @t=Tokendisplay.find_first(["counterno=?",params[:counter][:counterno]])
    if (@t==nil)
    @token=Tokendisplay.new
    @token.counterno=params[:counter][:counterno]
    @token.id=params[:counter][:counterno]
    @token.save
  end
   render :update do |page|

     page.redirect_to url_for(:controller=>'tellers', :action=>'list')
  
     
   end
   
end

       
end


    def create1
    p'in create'
    @totaltypes=0
    @type=0
    @counter = Counter.new(params[:counter])
    
    @type=Csmapping.find_first(["counterno=?",params[:counter][:counterno]])
    if(@type==nil)
      p "no service mapped"
      #render :action => 'new'
      
       render :update do |page|
       page.alert "no service mapped"
       end
  
    else
    
       if @counter.save
        p "service mapped"
      flash[:notice] = 'Teller was successfully created.'
      
      if (params[:type1]=='1')
      @map=Ctypemapping.new
      @map.counterno=params[:counter][:counterno]
      @map.ctypeid=1
      @map.save
      end
       if (params[:type2]=='2')
      @map=Ctypemapping.new
      @map.counterno=params[:counter][:counterno]
      @map.ctypeid=2
      @map.save
    end
     if (params[:type3]=='3')
      @map=Ctypemapping.new
      @map.counterno=params[:counter][:counterno]
      @map.ctypeid=0
      @map.save
    end
   
    
    if (params[:stype1]=='1')
     
      @map=Csmapping.new
      @map.counterno=params[:counter][:counterno]
      @s=Service.find_first(["id=?",1])
      @map.serviceid=@s.serviceid
      @map.save
    end
    
     if (params[:stype2]=='2')
      
      @map=Csmapping.new
      @map.counterno=params[:counter][:counterno]
      @s=Service.find_first(["id=?",2])
      @map.serviceid=@s.serviceid
      @map.save
    end
    
     if (params[:stype3]=='3')
     
      @map=Csmapping.new
      @map.counterno=params[:counter][:counterno]
      @s=Service.find_first(["id=?",3])
      @map.serviceid=@s.serviceid
      @map.save
    end
     if (params[:stype4]=='4')
     
      @map=Csmapping.new
      @map.counterno=params[:counter][:counterno]
      @s=Service.find_first(["id=?",4])
      @map.serviceid=@s.serviceid
      @map.save
    end
     if (params[:stype5]=='5')
     
      @map=Csmapping.new
      @map.counterno=params[:counter][:counterno]
      @s=Service.find_first(["id=?",5])
      @map.serviceid=@s.serviceid
      @map.save
    end
     if (params[:stype6]=='6')
     
      @map=Csmapping.new
      @map.counterno=params[:counter][:counterno]
      @s=Service.find_first(["id=?",6])
      @map.serviceid=@s.serviceid
      @map.save
    end
     if (params[:stype7]=='7')
     
      @map=Csmapping.new
      @map.counterno=params[:counter][:counterno]
      @s=Service.find_first(["id=?",7])
      @map.serviceid=@s.serviceid
      @map.save
    end
     if (params[:stype8]=='8')
     
      @map=Csmapping.new
      @map.counterno=params[:counter][:counterno]
      @s=Service.find_first(["id=?",8])
      @map.serviceid=@s.serviceid
      @map.save
    end
     if (params[:stype9]=='9')
     
      @map=Csmapping.new
      @map.counterno=params[:counter][:counterno]
      @s=Service.find_first(["id=?",9])
      @map.serviceid=@s.serviceid
      @map.save
    end
     if (params[:stype10]=='10')
      
      @map=Csmapping.new
      @map.counterno=params[:counter][:counterno]
      @s=Service.find_first(["id=?",10])
      @map.serviceid=@s.serviceid
      @map.save
    end
     if (params[:stype11]=='11')
     
      @map=Csmapping.new
      @map.counterno=params[:counter][:counterno]
      @s=Service.find_first(["id=?",11])
      @map.serviceid=@s.serviceid
      @map.save
    end
     if (params[:stype12]=='12')
     
      @map=Csmapping.new
      @map.counterno=params[:counter][:counterno]
      @s=Service.find_first(["id=?",12])
      @map.serviceid=@s.serviceid
      @map.save
    end
     if (params[:stype13]=='13')
      
      @map=Csmapping.new
      @map.counterno=params[:counter][:counterno]
      @s=Service.find_first(["id=?",13])
      @map.serviceid=@s.serviceid
      @map.save
    end
     if (params[:stype14]=='14')
      
      @map=Csmapping.new
      @map.counterno=params[:counter][:counterno]
      @s=Service.find_first(["id=?",14])
      @map.serviceid=@s.serviceid
      @map.save
    end
     if (params[:stype15]=='15')
      
      @map=Csmapping.new
      @map.counterno=params[:counter][:counterno]
      @s=Service.find_first(["id=?",15])
      @map.serviceid=@s.serviceid
      @map.save
    end
     if (params[:stype16]=='16')
      
      @map=Csmapping.new
      @map.counterno=params[:counter][:counterno]
      @s=Service.find_first(["id=?",16])
      @map.serviceid=@s.serviceid
      @map.save
    end

@t=Tokendisplay.find_first(["counterno=?",params[:counter][:counterno]])
    if (@t==nil)
    @token=Tokendisplay.new
    @token.counterno=params[:counter][:counterno]
    @token.id=params[:counter][:counterno]
    @token.save
    end
    render :update do |page|

page.redirect_to url_for(:controller=>'tellers', :action=>'list')
end
    else
      render :update do |page|

page.redirect_to url_for(:controller=>'tellers', :action=>'new')
end
    end
    
    end
  end
  
  
  
  def edit
    @counter = Counter.find(params[:id])
    @session['editcounter']=@counter.counterno
    
   
    
    
  end



def update_services
  p'update_services'
   p"#{params[:counter][:counterno]}"
   p "#{params[:csmapping][:serviceid]}"
 #

    if ((params[:csmapping][:serviceid])=="")
   render :update do |page|
     page.alert "Please Select the service"
    end
	else
		@map1=Csmapping.new        
		@map1.counterno=params[:counter][:counterno] 
      
		@map1.serviceid=params[:csmapping][:serviceid]	    
    @se1= Csmapping.find_first(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:csmapping][:serviceid]]) 
		   @session['editcounter'] = (params[:counter][:counterno])
       #p "counterno=#{@session['counter']}"
       
    if @se1==nil	
      @map1.save  
     
      #p "#{@session['counter']['counterno']}"
      
   render :update do |page|
    # p "added"
    #page.replace_html('counterservices', :partial=>'counterservices')
     page.replace_html('rep1', :partial=>'rep1')
    #page.alert "added"
    
    #page["service_#{c.id}"].visual_effect :highlight, :duration => 3.5
   end
    else
    render :update do |page| 
		page.alert "This Service is Already Assigned to Counter No.""#{params[:counter][:counterno] }"
		end 
	end 

end
end

 def update
     #p "#{@counter.counterno}"
     #@find=Counter.find_first(["counterno=?",params[:counter][:counterno]])
     if(params[:counter][:counterno]=="")
      p "in nil"
       render :update do |page|
       page.alert "Please Enter CounterNo"
     end
     
     #elsif(@find!=nil)
       #p "not nil"
       #render :update do |page|
       #page.alert "Please Enter Different CounterNo"
     #end
     else
    p"#{params[:counter][:counterno]}"
    @c=params[:counter][:counterno]
    @type=Csmapping.find_first(["counterno=?",params[:counter][:counterno]])
  @ctype=Ctypemapping.find_first(["counterno=?",params[:counter][:counterno]])
 
     
    if(@type==nil and params[:type1]==nil and params[:type2]==nil and params[:type3]==nil)
    render :update do |page|
       page.alert "Please select customer type and service"
     end
    elsif(@type==nil)
     
       render :update do |page|
       page.alert "Please select atleast one Service"
     end
     
     elsif(params[:type1]==nil and params[:type2]==nil and params[:type3]==nil)
      
       render :update do |page|
       page.alert "Please select atleast one Customer"
     end
     
        else
      @map=Counter.find_first(["counterno=?",params[:counter][:counterno]])
      @map.counterno=params[:counter][:counterno]
      @map.loginstatus=params[:counter][:loginstatus]
      @map.counterstatus=params[:counter][:counterstatus]
      @map.save
          
          
    #@counter =Counter.find(params[:id])
    

    #if @counter.update_attributes(params[:counter])
      flash[:notice] = 'Teller was successfully updated.'
       #if @counter.save
        
        
      
      if (params[:type1]=='1')
      @map=Ctypemapping.new
      @map.counterno=params[:counter][:counterno]
      @map.ctypeid=1
      @ct= Ctypemapping.find_first(["counterno = ? and ctypeid=1 ",params[:counter][:counterno]]) 
      if @ct==nil
      @map.save
      
      end
      else
          @ct= Ctypemapping.delete_all(["counterno = ? and ctypeid=1 ",params[:counter][:counterno]]) 
      end
    p "data saved"
    
       if (params[:type2]=='2')
      @map=Ctypemapping.new
      @map.counterno=params[:counter][:counterno]
      @map.ctypeid=2
      @ct1= Ctypemapping.find_first(["counterno = ? and ctypeid=2 ",params[:counter][:counterno]]) 
      if @ct1==nil
      @map.save
     
      end
       else
        @ct= Ctypemapping.delete_all(["counterno = ? and ctypeid=2 ",params[:counter][:counterno]]) 
    end
    p "data saved1"
     if (params[:type3]=='3')
      @map=Ctypemapping.new
      @map.counterno=params[:counter][:counterno]
      @map.ctypeid=3
      @ct= Ctypemapping.find_first(["counterno = ? and ctypeid=3 ",params[:counter][:counterno]]) 
      if @ct==nil
      @map.save
      
    end
    else
        @ct= Ctypemapping.delete_all(["counterno = ? and ctypeid=3 ",params[:counter][:counterno]]) 
      end
    #end
    p "data saved2"
    
     render :update do |page|

     page.redirect_to url_for(:controller=>'tellers', :action=>'list')
end
    end   
 end
  end
  
  
  def update1
     #p "#{@counter.counterno}"
    p"#{params[:counter][:counterno]}"
    @c=params[:counter][:counterno]
    if (params[:type1]==nil)
      
      @ct= Ctypemapping.delete_all(["counterno = ? and ctypeid=1 ",@c]) 
    end
    if (params[:type2]==nil)
      @ct= Ctypemapping.delete_all(["counterno = ? and ctypeid=2 ",@c]) 
    end
    if (params[:type3]==nil)
      @ct= Ctypemapping.delete_all(["counterno = ? and ctypeid=0 ",@c]) 
    end
    @counter =Counter.find(params[:id])
    if @counter.update_attributes(params[:counter])
      flash[:notice] = 'Teller was successfully updated.'
       #if @counter.save
        
        
      
      if (params[:type1]=='1')
      @map=Ctypemapping.new
      @map.counterno=params[:counter][:counterno]
      @map.ctypeid=1
      @ct= Ctypemapping.find_first(["counterno = ? and ctypeid=1 ",params[:counter][:counterno]]) 
      if @ct==nil
      @map.save
      else
      end
      
      end
    
       if (params[:type2]=='2')
      @map=Ctypemapping.new
      @map.counterno=params[:counter][:counterno]
      @map.ctypeid=2
      @ct1= Ctypemapping.find_first(["counterno = ? and ctypeid=2 ",params[:counter][:counterno]]) 
      if @ct1==nil
      @map.save
      else
      end
      
    end
    
     if (params[:type3]=='0')
      @map=Ctypemapping.new
      @map.counterno=params[:counter][:counterno]
      @map.ctypeid=0
      @ct= Ctypemapping.find_first(["counterno = ? and ctypeid=0 ",params[:counter][:counterno]]) 
      if @ct==nil
      @map.save
      else
      end
      end
    end
    
      redirect_to :action => 'list'
       

  end

  def destroy
    Counter.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
def back1
#Csmapping.delete_all(["counterno = ? ",params[:counter][:counterno]]) 
render :update do |page|

page.redirect_to url_for(:controller=>'tellers', :action=>'list')
end
end 
def back
Csmapping.delete_all(["counterno = ? ",params[:counter][:counterno]]) 
render :update do |page|

page.redirect_to url_for(:controller=>'tellers', :action=>'list')
end
end

 def back_ads
render :update do |page|

page.redirect_to url_for(:controller=>'tellers', :action=>'list_ad')
end
end 
  


def servicesmapped
end

def newad 
    @ad = Ad.new
end

  def create_ad
    @ad = Ad.new(params[:ad])
    if @ad.save
      flash[:notice] = 'Ad was successfully created.'
      redirect_to :action => 'list_ad'
    else
      render :action => 'newad'
    end
  end

 def edit_ad
    @ad = Ad.find(params[:id])
  end

  def update_ad
    @ad =Ad.find(params[:id])
    if @ad.update_attributes(params[:ad])
      flash[:notice] = 'Ad was successfully updated.'
      redirect_to :action => 'list_ad'
    else
      render :action => 'edit_ad'
    end
  end

  def destroy_ad
    Ad.find(params[:id]).destroy
    redirect_to :action => 'list_ad'
  end  
  
 def list_ad
    @ad_pages, @ads = paginate :ads, :per_page => 10
  end

def update_newservices
  p'update_newservices'
   p"#{params[:counter][:counterno]}"
   p "#{params[:csmapping][:serviceid]}"
   render :update do |page|
if ((params[:csmapping][:serviceid])=="")
     page.alert "Please Select the service"

   elsif ((params[:counter][:counterno])=="")
     page.alert "Please enter counterno"
     else
		@map1=Csmapping.new        
		@map1.counterno=params[:counter][:counterno] 
      
		@map1.serviceid=params[:csmapping][:serviceid]	    
    @se1= Csmapping.find_first(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:csmapping][:serviceid]]) 
		   @session['counter'] = (params[:counter][:counterno])
       p "counterno=#{@session['counter']}"
    @c=Counter.find_first(["counterno=?",params[:counter][:counterno]])
     if (@c==nil)
    if (@se1==nil)
      @map1.save  
     
      #p "#{@session['counter']['counterno']}"
      
   
    # p "added"
    #page.replace_html('counterservices', :partial=>'newservices')
    page.replace_html('rep', :partial=>'rep')
    #page.alert "added"
    
    #page["service_#{c.id}"].visual_effect :highlight, :duration => 3.5
   #end
    else
   # render :update do |page| 
		page.alert "This Service is Already Assigned to Counter No.""#{params[:counter][:counterno] }"
  #end 
end
else
  page.alert "counterno already taken"
  end
    
  end
  
  
	end 
end



def remove_services
  
  p "in remove"
  p"#{params[:counter][:counterno]}"
  p"#{params[:counter][:serviceid]}"
		@map1=Csmapping.new        
		@map1.counterno=params[:counter][:counterno] 
      
		@map1.serviceid=params[:counter][:serviceid]	    
    @se1= Csmapping.find_first(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:counter][:serviceid]]) 
   
      render :update do |page|
    if @se1==nil	
      
 
   page.alert "This service is not assigned to Counter No.""#{params[:counter][:counterno] }"  
    

    else
    @t= Csmapping.delete_all(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:counter][:serviceid]]) 
    p "record deleted"
     @session['counter'] = (params[:counter][:counterno])
    #page.replace_html('counterservices', :partial=>'newservices')
    page.replace_html('rep', :partial=>'rep')
	end 
   end

end



def all_services
  @e=params[:counter][:counterno]
  @session['counter'] = (params[:counter][:counterno])
  if @e==""
    p'c' 
    render :update do |page|
  p'r'
  page.alert "Please enter the counter No"
  end
  else
  @map1=Csmapping.new    
		#@map1.serviceid=params[:csmapping][:serviceid]	    
    @all=Service.find(:all)
    @all.each do |d|
      
      @map1=Csmapping.new        
      @map1.counterno=params[:counter][:counterno]
      @map1.serviceid=d.serviceid
      @se1= Csmapping.find_first(["counterno = ? and serviceid=? ",@map1.counterno,@map1.serviceid]) 
       if @se1==nil
      @map1.save  
    end
      
      end
  end
 render :update do |page|
   #page.replace_html('counterservices', :partial=>'newservices')
   page.replace_html('rep', :partial=>'rep')
   end
   
    #@t= Csmapping.delete_all(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:csmapping][:serviceid]]) 

	#end 

end

def remove_all
  #@re= Csmapping.find_all(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:csmapping][:serviceid]]) 
  #@re.each do |d|
  p'in r'
  
  Csmapping.delete_all(["counterno = ? ",params[:counter][:counterno]]) 
    @session['counter'] = (params[:counter][:counterno])
    
    render :update do |page|
   #page.replace_html('counterservices', :partial=>'newservices')
   page.replace_html('rep', :partial=>'rep')
   end
end

def remove_eservices1
  #p"#{params[:counter][:counterno]}"
  @session['editcounter'] = (params[:counter][:counterno])
		@map1=Csmapping.new        
		@map1.counterno=params[:counter][:counterno] 
      
		@map1.serviceid=params[:csmapping][:serviceid]	    
    @se1= Csmapping.find_first(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:csmapping][:serviceid]]) 
		 
    if @se1==nil	
      
   render :update do |page|
   page.alert "This service is not assigned to Counter No.""#{params[:counter][:counterno] }"  
    
   end
    else
    @t= Csmapping.delete_all(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:csmapping][:serviceid]]) 
   render :update do |page|
   #page.replace_html('counterservices', :partial=>'newservices')
   page.replace_html('rep1', :partial=>'rep1')
   end
	end 


end

def remove_eservices
  p "in remove"
  p"#{params[:counter][:counterno]}"
  p"#{params[:csmapping][:serviceid]}"
		@map1=Csmapping.new        
		@map1.counterno=params[:counter][:counterno] 
      
		@map1.serviceid=params[:counter][:serviceid]	    
    @se1= Csmapping.find_first(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:counter][:serviceid]]) 
    @session['editcounter'] = (params[:counter][:counterno])
    
      render :update do |page|
    if @se1==nil	
      
 
   page.alert "This service is not assigned to Counter No.""#{params[:counter][:counterno] }"  
    

    else
    @t= Csmapping.delete_all(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:counter][:serviceid]]) 
    p "record deleted"
    
    #page.replace_html('counterservices', :partial=>'counterservices')
  page.replace_html('rep1', :partial=>'rep1')
	end 
   end

end


def all_eservices11
  @e=params[:counter][:counterno]
 
  if @e==""
    p'c' 
    render :update do |page|
  p'r'
  page.alert "Please enter the counter No"
  end
  else
  @map1=Csmapping.new    
		#@map1.serviceid=params[:csmapping][:serviceid]	    
    @all=Service.find(:all)
    @all.each do |d|
      
      @map1=Csmapping.new        
      @map1.counterno=params[:counter][:counterno]
      @map1.serviceid=d.serviceid
      @map1.save    
      end
  end
 render :update do |page|
   #page.replace_html('counterservices', :partial=>'counterservices')
    page.replace_html('rep1', :partial=>'rep1')
   end
   
    #@t= Csmapping.delete_all(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:csmapping][:serviceid]]) 

	#end 

end

def all_eservices
  @e=params[:counter][:counterno]
  @session['editcounter'] = (params[:counter][:counterno])
  if @e==""
    p'c' 
    render :update do |page|
  p'r'
  page.alert "Please enter the counter No"
  end
  else
  @map1=Csmapping.new    
		#@map1.serviceid=params[:csmapping][:serviceid]	    
    @all=Service.find(:all)
    @all.each do |d|
      
      @map1=Csmapping.new        
      @map1.counterno=params[:counter][:counterno]
      @map1.serviceid=d.serviceid
       @se1= Csmapping.find_first(["counterno = ? and serviceid=? ",@map1.counterno,@map1.serviceid]) 
       if @se1==nil
      @map1.save  
    end
    
      end
  end
 render :update do |page|
   #page.replace_html('counterservices', :partial=>'counterservices')
   page.replace_html('rep1', :partial=>'rep1')
   end
   
    #@t= Csmapping.delete_all(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:csmapping][:serviceid]]) 

	#end 

end

def remove_eall
  #@re= Csmapping.find_all(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:csmapping][:serviceid]]) 
  #@re.each do |d|
  
  @session['editcounter'] = (params[:counter][:counterno])
  Csmapping.delete_all(["counterno = ? ",params[:counter][:counterno]]) 
    render :update do |page|
   #page.replace_html('counterservices', :partial=>'counterservices')
   page.replace_html('rep1', :partial=>'rep1')
   end
end


  
end
