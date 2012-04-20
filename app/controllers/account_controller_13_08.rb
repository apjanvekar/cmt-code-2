#An unpublished work of Sprylogic Technologies Ltd. 
# © Copyright Sprylogic Technologies Ltd. 2008. All rights reserved 


class AccountController < ApplicationController
  model   :user
 # layout  'scaffold'
 layout 'standard'
 
 #login method 
  def login
    case @request.method
      when :post
      
       if @session['user'] = User.authenticate(@params['user_login'], @params['user_password'])
	    
        #searching for logintype based on userlogin and userpassword
         @result=User.login_type(@params['user_login'],@params['user_password'])
	#p "logged by #{@session['user']['login']}"
         #global variables
         $gloginid=@result.login 
         #p $gloginid
         $gusertype=@result.usertype
         #gloginid
         #checking for user status  and loginstatus
	  if @result.userstatus=='1' 	
        if @result.userstatus=='1' and @result.loginstatus=='N'
		#if @result.userstatus=='1'
	   
	   @user=User.find(@result.id)
	   @user.loginstatus='Y'
	   @user.save
	   
	   #User.update(@result.id,{:loginstatus=>'Y'})
	
	#checking for usertype
	
	if @result.usertype=="Admin"
	  #flash['notice']  = "Login successful"
	  
	  #update counter table for loginstatus
	  #p "admin logged"
	redirect_to  :controller => 'users',:action => "admin"
	else
	  #p "User logged"
	redirect_to :controller =>'client',:action => "updateteller"
	
        end
         #********End if (usertype)*****************
        else
	  @message = "User is already logged in"
        end
	else
		@message="You cannot login !!"
	end 	 
         #********End if (userstatus)*****************
        else
	@login    = @params['user_login']
	@message  = "Login unsuccessful"
        end
        #********End if (user authentication)*****************
    end
  end
  
  
  
  def delete
    if @params['id'] and @session['user']
      @user = User.find(@params['id'])
      @user.destroy
    end
    redirect_to :action => "welcome"
  end  
    
    
  #function for logout currently using  
  def logout1
     begin
     #find user with current loginid and set its loginstatus='N'
    #****************Complete the token if serving while logging out******************************
    @counter=User.find_first(["login=?",@session['user']['login']])
    @transact= Transact.find_first(["tokenstatus=2 and counterno=?",@counter.counterno])    
Tokendisplay.update(@counter.counterno,{:tokenno=>'0000'})   
  render :update do |page|
    if @transact==nil 
      @user= User.find_first(["login = ? and loginstatus='Y'",@session['user']['login']])
     #p "#{@user.counterno}"
        @c=User.update(@user.id,{:loginstatus=>'N', :counterno=>"0"})
        p "user #{@user.login} logged out from counter #{@user.counterno}"
        
     #find counter with current loginid and set its loginstatus='N'
     @counter1=Counter.find_first(["counterno=? and loginstatus='Y'",@user.counterno])
	
     @b= Counter.update(@counter1.id,{:loginstatus=> 'N'}) 
  
   
    # p "logged out from counterno #{@b.counterno}"
    
    
       
    @session['user'] = nil

     page.redirect_to url_for(:controller=>'account', :action=>'logout')
        #redirect_to :action => "logout"
    else
	if params[:transact][:stpname]==""
	   page.alert 'Please Select Stpname'
        
         elsif params[:transact][:nonstpname]!="" and params[:transact][:accno]=="" 
	  #if params[:transact][:accno]==""
	  page.alert 'Please Enter Account number'
         # end
         elsif params[:transact][:bulkcount]=="" and params[:transact][:nonstpname]!=""
	p "in "
	  page.alert 'Please Enter Bulk count'
       else
    if @transact.update_attributes(params[:transact])
    #new code
    #    Wait time = generatedtime-currenttime"   
    #@gwaittime=User.time_diff_in_minutes(@transact.generatedtime,Time.now())
    # servicedtime= time when service is served"   
    @gservicedtime=Time.now()
     # timetaken= servicedtime-calledtime"
     #@gtimetaken=User.time_diff_in_minutes(@gservicedtime,@transact.calledtime)
     @gtimetaken=User.time_diff_in_minutes(@transact.calledtime,Time.now())
         # p "#{@gtimetaken}"
        
        #missing logic not used currently over here
         #checking whether the missed is clicked or not if yes then update tokenstatus=3 else tokenstatus=1
	        if (params[:missed]=='on')
	      # render :text =>"value is on"
	        #User.hi
	        @b=Transact.find_all(["tokenid=? and serviceid=?",@transact.tokenid,@transact.serviceid])
	  if @transact.missingflag==nil 
	    @b.each do |b|
	      b.tokenstatus=3
	      b.missingflag=1
	      b.save
	     end 
	  #@b= Transact.update(@transact.id,{:tokenstatus=> '3',:missingflag=>'1'})
	else
	  @b.each do |b|
	     b.tokenstatus=3
	     b.missingflag=2
	     b.save
	     end
	  #@b= Transact.update(@transact.id,{:tokenstatus=> '3'})
	end
	@c=Transact.find_all(["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
        @c.each do |c|
        c.tokenstatus=0
        c.save
        end    
        else
       
       @b= Transact.update(@transact.id,{:tokenstatus=> '1', :servicedtime=>Time.now(),:timetaken => @gtimetaken}) 
       @c=Transact.find_all(["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
       @c.each do |c|
       c.tokenstatus=0
       c.save
       end      
	@t= Transact.delete_all(["tokenstatus=4 and tokenid= ? and counterno<>? and serviceid=?",@transact.tokenid,@counter.counterno,@transact.serviceid])
	 
        end
       
     end
     @user= User.find_first(["login = ? and loginstatus='Y'",@session['user']['login']])
     #p "#{@user.counterno}"
        @c=User.update(@user.id,{:loginstatus=>'N', :counterno=>"0"})
        p "user #{@user.login} logged out from counter #{@user.counterno}"
        
     #find counter with current loginid and set its loginstatus='N'
     @counter1=Counter.find_first(["counterno=? and loginstatus='Y'",@user.counterno])
	
     @b= Counter.update(@counter1.id,{:loginstatus=> 'N'}) 
  
   
    # p "logged out from counterno #{@b.counterno}"
    
    
       
    @session['user'] = nil

     page.redirect_to url_for(:controller=>'account', :action=>'logout')
        #redirect_to :action => "logout"
     
   end
   
   
end

    #*****************************End*************************
     
    
     
     
     
 end
    rescue Exception => exc
    #STDERR.puts "Error is #{exc.message}"
  end
  end
    
 
 
 #this logout method not implemented currently
  def logout
     begin
     #find user with current loginid and set its loginstatus='N'
    
    #****************Complete the token if serving while logging out******************************
    @counter=User.find_first(["login=?",@session['user']['login']])
    @transact= Transact.find_first(["tokenstatus=2 and counterno=?",@counter.counterno])    
    
    if @transact==nil 
     
    else
     
       
     
     # p 'saving pause'
      if @transact.update_attributes(params[:transact])
       
     
	
	#new code
	        #    Wait time = generatedtime-currenttime"   
        #@gwaittime=User.time_diff_in_minutes(@transact.generatedtime,Time.now())
       
        # servicedtime= time when service is served"   
        @gservicedtime=Time.now()
        
        # timetaken= servicedtime-calledtime"
        #@gtimetaken=User.time_diff_in_minutes(@gservicedtime,@transact.calledtime)
	@gtimetaken=User.time_diff_in_minutes(@transact.calledtime,Time.now())
	p "#{@gtimetaken}"
	
         #checking whether the missed is clicked or not if yes then update tokenstatus=3 else tokenstatus=1
	        if (params[:missed]=='on')
	      # render :text =>"value is on"
	        #User.hi
	        @b=Transact.find_all(["tokenid=? and serviceid=?",@transact.tokenid,@transact.serviceid])
	  if @transact.missingflag==nil 
	    @b.each do |b|
	      b.tokenstatus=3
	      b.missingflag=1
	      b.save
	     end 
	  #@b= Transact.update(@transact.id,{:tokenstatus=> '3',:missingflag=>'1'})
	else
	  @b.each do |b|
	     b.tokenstatus=3
	     b.missingflag=2
	     b.save
	     end
	  #@b= Transact.update(@transact.id,{:tokenstatus=> '3'})
	end
	@c=Transact.find_all(["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
        @c.each do |c|
        c.tokenstatus=0
        c.save
        end    
        else
        @b= Transact.update(@transact.id,{:tokenstatus=> '1', :servicedtime=>Time.now(),:timetaken => @gtimetaken}) 
       
       @c=Transact.find_all(["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
        @c.each do |c|
        c.tokenstatus=0
        c.save
        end      
	@t= Transact.delete_all(["tokenstatus=4 and tokenid= ? and counterno<>? and serviceid=?",@transact.tokenid,@counter.counterno,@transact.serviceid])
	 
	#end new code
      end
    end
    end
    #*****************************End*************************
     
    
     
     
     @user= User.find_first(["login = ? and loginstatus='Y'",@session['user']['login']])
     #p "#{@user.counterno}"
        @c=User.update(@user.id,{:loginstatus=>'N', :counterno=>0})
        p "user #{@user.login} logged out from counter #{@user.counterno}"
        
     #find counter with current loginid and set its loginstatus='N'
     @counter1=Counter.find_first(["counterno=? and loginstatus='Y'",@user.counterno])
	
     @b= Counter.update(@counter1.id,{:loginstatus=> 'N'}) 
  
   
    # p "logged out from counterno #{@b.counterno}"
    
    
       
    @session['user'] = nil

    #render :update do |page|
    #page.alert "Taking pause will end the current service request"
    #end  
        #redirect_to :action => "login"

    rescue Exception => exc
    
    #STDERR.puts "Error is #{exc.message}"
  end
  
  end
    
    
def logout2
  begin
    #find user with current loginid and set its loginstatus='N'
    #****************Complete the token if serving while logging out******************************
    @counter=User.find_first(["login=?",@session['user']['login']])
    @transact= Transact.find_first(["tokenstatus=2 and counterno=?",@counter.counterno])    
    Tokendisplay.update(@counter.counterno,{:tokenno=>'0000'})   
  render :update do |page|
    if @transact==nil 
      @user= User.find_first(["login = ? and loginstatus='Y'",@session['user']['login']])
      #p "#{@user.counterno}"
        @c=User.update(@user.id,{:loginstatus=>'N', :counterno=>"0"})
        p "user #{@user.login} logged out from counter #{@user.counterno}"
        
     #find counter with current loginid and set its loginstatus='N'
     @counter1=Counter.find_first(["counterno=? and loginstatus='Y'",@user.counterno])
	
     @b= Counter.update(@counter1.id,{:loginstatus=> 'N'}) 
    
    # p "logged out from counterno #{@b.counterno}"
    @session['user'] = nil
    page.redirect_to url_for(:controller=>'account', :action=>'logout')
        #redirect_to :action => "logout"
    else
        #if params[:transact][:stpname]==""
        # page.alert 'Please Select Stpname'
        #elsif params[:transact][:nonstpname]!="" and params[:transact][:accno]=="" 
        #if params[:transact][:accno]==""
        # page.alert 'Please Enter Account number'
        # end
        #elsif params[:transact][:bulkcount]=="" and params[:transact][:nonstpname]!=""
        #p "in "
        #page.alert 'Please Enter Bulk count'
        #else
    if @transact.update_attributes(params[:transact])
    #new code
    #Wait time = generatedtime-currenttime"   
    #@gwaittime=User.time_diff_in_minutes(@transact.generatedtime,Time.now())
    # servicedtime= time when service is served"   
    @gservicedtime=Time.now()
     # timetaken= servicedtime-calledtime"
     #@gtimetaken=User.time_diff_in_minutes(@gservicedtime,@transact.calledtime)
     @gtimetaken=User.time_diff_in_minutes(@transact.calledtime,Time.now())
         # p "#{@gtimetaken}"
         #missing logic not used currently over here
         #checking whether the missed is clicked or not if yes then update tokenstatus=3 else tokenstatus=1
	        if (params[:missed]=='on')
	      # render :text =>"value is on"
	        #User.hi
	        @b=Transact.find_all(["tokenid=? and serviceid=?",@transact.tokenid,@transact.serviceid])
	  if @transact.missingflag==nil 
	    @b.each do |b|
	      b.tokenstatus=3
	      b.missingflag=1
	      b.save
	     end 
	  #@b= Transact.update(@transact.id,{:tokenstatus=> '3',:missingflag=>'1'})
	else
	  @b.each do |b|
	     b.tokenstatus=3
	     b.missingflag=2
	     b.save
	     end
	  #@b= Transact.update(@transact.id,{:tokenstatus=> '3'})
	end
	@c=Transact.find_all(["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
        @c.each do |c|
        c.tokenstatus=0
        c.save
        end    
        else
       p "data saving"
       
       @b= Transact.update(@transact.id,{:tokenstatus=> '1', :servicedtime=>Time.now(),:timetaken => @gtimetaken}) 
       @c=Transact.find_all(["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
       @c.each do |c|
       c.tokenstatus=0
       c.save
       end      
	@t= Transact.delete_all(["tokenstatus=4 and tokenid= ? and counterno<>? and serviceid=?",@transact.tokenid,@counter.counterno,@transact.serviceid])
	 
        end
       
     end
     @user= User.find_first(["login = ? and loginstatus='Y'",@session['user']['login']])
     #p "#{@user.counterno}"
        @c=User.update(@user.id,{:loginstatus=>'N', :counterno=>"0"})
        p "user #{@user.login} logged out from counter #{@user.counterno}"
        
     #find counter with current loginid and set its loginstatus='N'
     @counter1=Counter.find_first(["counterno=? and loginstatus='Y'",@user.counterno])
	
     @b= Counter.update(@counter1.id,{:loginstatus=> 'N'}) 
    # p "logged out from counterno #{@b.counterno}"
     @session['user'] = nil
     page.redirect_to url_for(:controller=>'account', :action=>'logout')
     #redirect_to :action => "logout"
   #end
end
    #*****************************End*************************
end
    rescue Exception => exc
    #STDERR.puts "Error is #{exc.message}"
  end
  end


end

