#An unpublished work of Sprylogic Technologies Ltd. 
# © Copyright Sprylogic Technologies Ltd. 2008. All rights reserved 

class ClientController < ApplicationController

def updateteller
begin
     session[:count]=0
     session[:timer]=false
     session[:flag]=false
      @counterid=params[:updateteller][:counterno]
     
      @counter=Counter.find_first(["counterno = ? and loginstatus='N' and counterstatus=1",@counterid])
    #@teller=Teller.find, :conditions => loginstatus='N')
    
    if @counter==nil
       #p 'Counter is already logged in'
       flash[:notice] = 'Counter is already logged in... '
          @message  = "Wrong teller"
       #render :action => 'updateteller'
        #redirect_to :controller => 'account', :action => "logout"         
    else
       # $counterno=@counter.counterno
        #p $counterno
       
      @b= Counter.update(@counter.id,{:loginstatus=> 'Y'}) 
      #p "Counter logging by #{@teller.id}"
      #update counterno in user table
      @c=User.find_first(["login=?",@session['user']['login']])
      #p "user is logged with #{@c.login}"
      
      User.update(@c.id , {:counterno=> @counter.counterno})
      
       #p "User is logged to counter  #{@session['user']['counterno']}"
      flash[:notice] = 'logged in... '
      
      #modified code under construction
      @counter=User.find_first(["login=?",@session['user']['login']])
      #@pendingtoken =Transact.find_first(["tokenstatus=0 and counterno=?",@counter.counterno])
       @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0 and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:limit=>1)        
              #p "#{pendingtoken}"
              
              if(@pendingtoken==nil)
                    redirect_to :action => "transact"
                    else
                       @update=Transact.update(@pendingtoken.id,{:tokenstatus=>2}) 
                      #@t= Transact.find_all(:all,:conditions=>["tokenstatus=0 and tokenid= ? and counterno<>? ",@pendingtoken.tokenid,@counter.counterno],:lock=>true) 
                       @t= Transact.find_all(["tokenstatus=0 and id<>? and tokenno=?",@pendingtoken.id,@pendingtoken.tokenno]) 
                            	  @t.each do |c| 
                            	    c.tokenstatus=4 
                            	     c.save 
                            	     end
                    redirect_to :action => "status"
      end
      
      #redirect_to  :controller => 'users',:action => "updatetoken"
      
     
   end
   rescue Exception => exc
    
    #STDERR.puts "Error is #{exc.message}"
  end

end

#updatetransact function for updating tokenstatus and showing current token to be served
def updatetransact  
   begin
    session[:gvar]=0
    session[:b]=0
    session[:flag]=false
     @counter=User.find_first(["login=?",@session['user']['login']])
    @transact= Transact.find_first(["tokenstatus=2 and counterno=?",@counter.counterno])   
    
  # p @transact.login
    if @transact==nil
    
     #modified code under construction
              @counter=User.find_first(["login=?",@session['user']['login']])
              #@pendingtoken =Transact.find_first(["tokenstatus=0 and counterno=?",@counter.counterno])
              @pendingtoken1 =Transact.find(:first,:conditions=>["tokenstatus=0 and callflag='N'"],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:lock=> 'LOCK IN SHARE MODE') 
		if(@pendingtoken1!=nil)
		
	@pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0 and callflag='N' and  counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:lock=> 'LOCK IN SHARE MODE') 
              #p "IN UPDATETRANSCAT"
              
              if(@pendingtoken==nil)
                    redirect_to :action => "transact"
                    else
		#token=@pendingtoken.tokenno;
		#@u=Transact.update_all("callflag='Y'","tokenno like '%token%'")
		@u=Transact.find(:all,:conditions=>["tokenstatus=0 and tokenno=? and callflag='N'",@pendingtoken.tokenno],:lock=>'LOCK IN SHARE MODE')
		@u.each do |u|
		u.callflag=@counter.counterno
		u.save
		end
                
		@save=Transact.find(:first,:conditions=>["counterno=? and callflag=? and tokenstatus=0",@pendingtoken.counterno,@pendingtoken.counterno],:lock=>"LOCK IN SHARE MODE")
		
		if(@save!=nil)
                @update=Transact.update(@save.id,{:tokenstatus=>2})      
		
		
@t= Transact.find(:all,:conditions=>["tokenstatus=0 and callflag=? and id<>? and tokenno=?",@counter.counterno,@update.id,@update.tokenno],:lock=>"LOCK IN SHARE MODE")     
	
                            	  @t.each do |c| 
                            	    c.tokenstatus=4 
                            	     c.save 
                            	     end                    
                    #@a= Transact.find_first(["counterno = ? AND tokenstatus=2",@counter.counterno])
		    #if(@a!=nil)	
                    redirect_to :action => "statusview"
			end
			end
                    else
                    redirect_to :action => "transact"
                    end
      #end
      #render :action => 'transact'
        else
    
      if @transact.update_attributes(params[:transact])
        
        #    Wait time = generatedtime-currenttime"   
        #@gwaittime=User.time_diff_in_minutes(@transact.generatedtime,Time.now())
       
        # servicedtime= time when service is served"   
        @gservicedtime=Time.now()
        
        # timetaken= servicedtime-calledtime"
        #@gtimetaken=User.time_diff_in_minutes(@gservicedtime,@transact.calledtime)
	  if @transact.missingflag==nil
          @gtimetaken=User.time_diff_in_minutes(@transact.calledtime,Time.now())
	else
       @gtimetaken=User.time_diff_in_minutes(@transact.call1,Time.now())
       end
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
        @b= Transact.update(@transact.id,{:tokenstatus=> '1', :servicedtime=>@gservicedtime,:timetaken => @gtimetaken}) 
       
       @c=Transact.find_all(["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
        @c.each do |c|
        c.tokenstatus=0
        c.save
        end      
          @t= Transact.delete_all(["tokenstatus=4 and tokenid= ? and counterno<>? and serviceid=?",@transact.tokenid,@counter.counterno,@transact.serviceid])
           
      end
    
    
          #modified code under construction
          @counter=User.find_first(["login=?",@session['user']['login']])
          #@pendingtoken =Transact.find_first(["tokenstatus=0 and counterno=?",@counter.counterno])
            @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0 and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:lock=>true)   
              #p "#{pendingtoken}"
              
              if(@pendingtoken==nil)
                    redirect_to :action => "transact"
                    else
                       @update=Transact.update(@pendingtoken.id,{:tokenstatus=>2}) 
                      #@t= Transact.find_all(["tokenstatus=0 and tokenid= ? and counterno<>? ",@pendingtoken.tokenid,@counter.counterno]) 
                           @t= Transact.find_all(["tokenstatus=0 and id<>? and tokenno=?",@pendingtoken.id,@pendingtoken.tokenno])  	
                            	  @t.each do |c| 
                            	    c.tokenstatus=4 
                            	     c.save 
                            	     end
                    redirect_to :action => "status"
      end
        #redirect_to  :action => 'transact'
           
      else
        #p "redirecting"
      render  :action => 'transact'
    
    end
    end
rescue Exception => exc
redirect_to :action => "updatetransact"
end
  end
  
def statusview
 @counter=User.find_first(["login=?",@session['user']['login']])

 @a= Transact.find_first(["counterno = ? AND tokenstatus=2",@counter.counterno])
	 if @a==nil 
	 redirect_to :action=> "updatetransact" 
	
	 else 
	redirect_to :action=>"status"
	end
end

def shrinksave_pause
@counter=User.find_first(["login=?",@session['user']['login']]) 
@transact= Transact.find_first(["pauseflag=1 and counterno=?",@counter.counterno])    
#@reason=params[:auxreason][:reasons]
@reason='Lunch'
@b= Pause.update(@transact.counterno,{:reason=> 'Lunch'})
#p "Reason selected was #{@reason}"

end

def time
     begin   
     #p "falg = #{session[:flag]}"
     @counter=User.find_first(["login=?",@session['user']['login']])
     @transact= Transact.find_first([" counterno=?  ",@counter.counterno])     
    session[:gvar]=session[:gvar]+5
    
    if session[:gvar]>60
     session[:b]=session[:b]+1
     session[:gvar]=0
    @c="00:0#{session[:b]}:#{session[:gvar]}"
    @time=Service.find_first(["serviceid=? and thresholdtime=?",@transact.serviceid,@c])
    if (@time==nil and session[:flag]==false)
     render :text=> " 00:0#{session[:b]}:#{session[:gvar]}" 
    elsif session[:flag]==true
      @p=render :text=> '<font color=red size=4><b>'+"00:0#{session[:b]}:#{session[:gvar]}" +'</b></font>'
      #flag=true
    else
      @p=render :text=> '<font color=red size=4><b>'+"00:0#{session[:b]}:#{session[:gvar]}" +'</b></font>'
      session[:flag]=true
    end
    
    else
      
    @f="00:0#{session[:b]}:#{session[:gvar]}"  
    @time=Service.find_first(["serviceid=? and thresholdtime=?",@transact.serviceid,@f])
    if (@time==nil and session[:flag]==false)
     render :text=> " 00:0#{session[:b]}:#{session[:gvar]}" 
    elsif session[:flag]==true
      @p=render :text=> '<font color=red size=4><b>'+"00:0#{session[:b]}:#{session[:gvar]}" +'</b></font>'
      #flag=true
    else
      @p=render :text=> '<font color=red size=4><b>'+"00:0#{session[:b]}:#{session[:gvar]}" +'</b></font>'
      session[:flag]=true
    end
   #render :text=>" 00:0#{session[:b]}:#{session[:gvar]}" 
  end
 rescue Exception => exc
     
     #STDERR.puts "Error is #{exc.message}"
     end  
end

#function for retrieving current counter logged in
def token
  #p "#{params[:id]}"
    # $counter = Counter.find(params[:id])
     @session['token'] = Counter.find(params[:id])
  #p "counter no is #{$counter}" 
    #
end

#missing function for redirecting to missing view
def missing
  render :update do |page|
      # page.replace_html 'aux_div', 'Please wait releasing pause ....'
    page.redirect_to url_for(:controller=>'client', :action=>'displaymissing')
    #page.form.reset :form1
    end
end
 
#Redirect Method
def redirect
          #redirecting the current token to onther counter by updating its token status=0 and who is redirecting as 5
        @counter=User.find_first(["login=?",@session['user']['login']])

        @transact= Transact.find_first(["tokenstatus=2 and counterno=?",@counter.counterno])   
        @b= Transact.update(@transact.id,{:tokenstatus=> '5'}) 
       p "ID= #{params[:id]}"
        
        @session['redirecttoken'] = Counter.find(params[:id])
        p "#{@session['redirecttoken']['counterno']}"
        
       @transact2=Transact.new
       @transact2.tokenno=@transact.tokenno
       @transact2.tokenid=@transact.tokenid
       @transact2.generatedtime=@transact.generatedtime
       @transact2.transdate=@transact.transdate
       @transact2.serviceid=@transact.serviceid
       @transact2.ctypeid=@transact.ctypeid
        @transact2.counterno=@session['redirecttoken']['counterno']
       @transact2.redirecttime=Time.now()
       @transact2.tokenstatus=0
       #@transact2.counterno=@counter.counterno
       
        @transact2.save
       
       #code for releasing token for other services
       @c=Transact.find_all(["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
        @c.each do |c|
        c.tokenstatus=0
        c.save
        end      
          @t= Transact.delete_all(["tokenstatus=4 and tokenid= ? and counterno<>? and serviceid=?",@transact.tokenid,@counter.counterno,@transact.serviceid])
        
       #end
       
       
       
        p "redirected properly"
        redirect_to  :action => 'updatetransact'

      
end
# End if Redirect method


#old Redirect Method for redirecting token to counter having similar service mapped
def redirect111
          #redirecting the current token to onther counter by updating its token status=0 and who is redirecting as 5
        @counter=User.find_first(["login=?",@session['user']['login']])

        @transact= Transact.find_first(["tokenstatus=2 and counterno=?",@counter.counterno])   
        @b= Transact.update(@transact.id,{:tokenstatus=> '5'}) 
       p "ID= #{params[:id]}"
        
        @session['redirecttoken'] = Transact.find(params[:id])
        p "#{@session['redirecttoken']['counterno']}"
        
 @transact2= Transact.find_first(["counterno=? and tokenno=? and tokenstatus=4",@session['redirecttoken']['counterno'],@session['redirecttoken']['tokenno']])   
 
 #p "#{@transact2.counterno}"
      if @transact2!=nil
       #@transact2.tokenstatus=0
       @transact2.redirecttime=Time.now()
       @transact2.tokenstatus=0
       #@transact2.counterno=@counter.counterno
       
        @transact2.save
        p "redirected properly"
        redirect_to  :action => 'updatetransact'
      end
      
        #@transact1= Transact.find_all(["tokenstatus=4 and tokenid= ?  and counterno<>?",@transact.tokenid,@counter.counterno])   
        #p "Rows = #{@transact1}"
       
        #if @transact1==nil
        
       
        #else
        #updating tokenstatus to be 0 for same token pending at others counters
        #@transact1.each do |c|
        #c.tokenstatus=0
        #c.save
        #p 'record updated'
        #end
  
       # #@t= Transact.update(["tokenstatus=0 and tokenid= ? and counterno<>?",@transact.tokenid,$counterno])
       # #page.redirect_to url_for(:controller=>'client', :action=>'updatetransact')
        ##page.form.reset :form1
        
        #end
      
end
# End if Redirect method


def redirecting
 render :update do |page|
      # page.replace_html 'aux_div', 'Please wait releasing pause ....'
    page.redirect_to url_for(:controller=>'client', :action=>'tokenredirect')
    #page.form.reset :form1
    end
end


def password_changed
end
def pass_change
  p'in pass'
  render :update do |page|
      # page.replace_html 'aux_div', 'Please wait releasing pause ....'
    page.redirect_to url_for(:controller=>'client', :action=>'transact')
    #page.form.reset :form1
    end
end

def password
 p "hello"
   #@user = @session['user']
   @user=User.find(@session['user'])
   #@session['message'] = nil
   #render :update do |page|
   case @request.method
      when :post   
        unless @user.password_check?(@params['old_password'])        
          #page.replace_html 'passwd', 'You have introduced a wrong password!'        
          @msg = 'You have introduced a wrong old password!'
          else
          unless @params['new_password'] == @params['new_password_confirmation']
            @msg = 'Your new password and password confirmation dont match!'
            else
          if @user.change_password(@params['new_password'])
            end
               
                  
                  redirect_to :controller=>'client', :action=>'password_changed'   
            
         
                 #page << "document.getElementById('pass').style.visibility = 'hidden'"

          end 
          #redirect_back_or_default :controller => "client", :action => "transact" 
          #page.redirect_to url_for(:controller=>"users", :action => "change_password")
          #redirect_back_or_default :controller => "client", :action => "transact" 
        end
      end
      
    #end
  end
  
  
def passwordold
   #@user = @session['user']
   @user=User.find(@session['user'])
   #@session['message'] = nil
   #render :update do |page|
   case @request.method
      when :post   
        unless @user.password_check?(@params['old_password'])        
          #page.replace_html 'passwd', 'You have introduced a wrong password!'        
          @msg = 'You have introduced a wrong old password!'
          else
          unless @params['new_password'] == @params['new_password_confirmation']
            @msg = 'Your new password and password confirmation dont match!'
            else
            @msg = 'Your password was changed successfully!' if @user.change_password(@params['new_password'])
            #page.alert("password changed successfully")
              #page.redirect_to url_for(:controller=>'client', :action=>'transact')
            end
          end 
          #redirect_back_or_default :controller => "client", :action => "transact" 
          #page.redirect_to url_for(:controller=>"users", :action => "change_password")
          #redirect_back_or_default :controller => "client", :action => "transact" 
        end
      #end
      
    #end
  end
  
def password1 

#@user = User.find(params[:id]) 
@user=User.find(@session['user'])

p "#{@user.login}"
if request.post? 
if User.authenticate(@user.login,@params['old_password']) == @user 
  p "matched"
@user.password = @params['new_password']
@user.password_confirmation = @params['new_password_confirmation']
if @user.save 
flash[:notice] = 'Your password has been changed' 
redirect_to :controller=>'client',:action => 'transact' 
else 
flash[:error] = 'Unable to change your password' 
end 
else 
flash[:error] = 'Invalid password' 
end 
end 
end 

def call_missing
#p "#{$callid}"

  @transact2= Transact.find_first(["tokenno=?",$tokenno])   
  
  #p "record found #{@transact2.tokenstatus}"
  #@transact2.each do |c|
       @transact2.tokenstatus=0
        @transact2.save
        #p 'record updated'
      #end
render :update do |page|
#Transact.update($callid,{:tokenstatus=>0}) 
page.redirect_to url_for(:controller=>'client', :action=>'updatetransact')
end

end


#function for tokenpulling
def calltoken
#p "tokenid=#{params[:id]}"  
@counter=User.find_first(["login=?",@session['user']['login']]) 
@session['calltoken'] = Transact.find(params[:id])
p "#{@session['calltoken']['counterno']}"

 @transact2= Transact.find_first(["tokenno=? and id=? and tokenstatus=0",@session['calltoken']['tokenno'],@session['calltoken']['id']])   
 
 #p "#{@transact2.counterno}"
      if @transact2!=nil
       #@transact2.tokenstatus=0
       @transact2.pullcounter=@transact2.counterno
       @transact2.counterno=@counter.counterno
       
        @transact2.save
        end
       redirect_to  :action => 'updatetransact'
       
end

  


def save_pause
  begin
  
@counter=User.find_first(["login=?",@session['user']['login']]) 
p "#{params[:transact][:reasons]}"
render :update do |page|

if params[:transact][:reasons]==""
 # p 'value is null for reasons'
  @msg = 'Please select pause time!'
  page.alert "Please Select Pause Reason!"
   #render  :action => 'transact'
else

@transact= Transact.find_first(["pauseflag=1 and counterno=?",@counter.counterno])    
@transact.reasons=params[:transact][:reasons]
@transact.save

@pause= Pausedetail.find_first(["pflag=1 and counterno=?",@counter.counterno])    
@pause.reason=params[:transact][:reasons]
@pause.save

#@b= Pause.update(@transact.counterno,{:reason=> 'Lunch'})
#p "Reason selected was #{@reason}"
       page.replace_html 'aux_div', 'You are in Pause Mode ....'
    #page.redirect_to url_for(:controller=>'client', :action=>'updatetransact')
    page << "document.getElementById('Release').disabled = false;"
     page << "document.getElementById('show').style.visibility = 'visible'"
     page << "document.getElementById('pausetime').style.visibility = 'visible'"
    #page.form.reset :form1
  end

end

 rescue Exception => exc
    
    #STDERR.puts "Error is #{exc.message}"
  end
end


def updateshrink
  
 @counter=User.find_first(["login=?",@session['user']['login']])
  @transact= Transact.find_first(["tokenstatus=2 and counterno=?",@counter.counterno])       
    if @transact==nil 
      #render :action => 'shrink1'
     
      
              @counter=User.find_first(["login=?",@session['user']['login']])
              #@pendingtoken =Transact.find_first(["tokenstatus=0 and counterno=?",@counter.counterno])
              @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0 and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:limit=>1) 
              #p "IN UPDATETRANSCAT"
              
              if(@pendingtoken==nil)
                    redirect_to :action => "shrink1"
                    else
                    #@calledtime= Time.now().strftime("%H:%M:%S")

                    @update=Transact.update(@pendingtoken.id,{:tokenstatus=>2}) 
                      #@t= Transact.find_all(["tokenstatus=0 and tokenid= ? and counterno<>? ",@pendingtoken.tokenid,@counter.counterno]) 
                        @t= Transact.find_all(["tokenstatus=0 and id<>? and tokenno=?",@pendingtoken.id,@pendingtoken.tokenno])     	
                            	  @t.each do |c| 
                            	    c.tokenstatus=4 
                            	     c.save 
                            	     end
                            	    

                    redirect_to :action => "shrinkstatus"
      end
      
      
      
    else
    if @transact.update_attributes(params[:transact])
       
        #    Wait time = generatedtime-currenttime"   
        #@gwaittime=User.time_diff_in_minutes(@transact.generatedtime,Time.now())
       
        # servicedtime= time when service is served"   
        @gservicedtime=Time.now()
        
        # timetaken= servicedtime-calledtime"
        #@gtimetaken=User.time_diff_in_minutes(@gservicedtime,@transact.calledtime)
          @gtimetaken=User.time_diff_in_minutes(@transact.calledtime,Time.now())
          
         #checking whether the missed is clicked or not if yes then update tokenstatus=3 else tokenstatus=1
                  if (params[:missed]=='on')

            @t= Transact.find_all(["tokenid= ?",@transact.tokenid])
             
            #updating tokenstatus to be 1 for same token pending at others counters
            @t.each do |c| 
                          c.tokenstatus=3
            c.calledtime=@transact.calledtime
            c.save
            end 

        else
        
        @b= Transact.update(@transact.id,{:tokenstatus=> '1',:servicedtime=>@gservicedtime,:timetaken => @gtimetaken}) 
         
           @t= Transact.delete_all(["tokenstatus=1 and tokenid= ? and counterno<>?",@transact.tokenid,@counter.counterno])
          
        end
        
         @counter=User.find_first(["login=?",@session['user']['login']])
              #@pendingtoken =Transact.find_first(["tokenstatus=0 and counterno=?",@counter.counterno])
              @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0 and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:limit=>1) 
              #p "IN UPDATETRANSCAT"
              
              if(@pendingtoken==nil)
                    redirect_to :action => "shrink1"
                    else
                       #@calledtime= Time.now().strftime("%H:%M:%S")
                     @update=Transact.update(@pendingtoken.id,{:tokenstatus=>2}) 
                      #@t= Transact.find_all(["tokenstatus=0 and tokenid= ? and counterno<>? ",@pendingtoken.tokenid,@counter.counterno]) 
                         @t= Transact.find_all(["tokenstatus=0 and id<>? and tokenno=?",@pendingtoken.id,@pendingtoken.tokenno])    	
                            	  @t.each do |c| 
                            	    c.tokenstatus=4 
                            	     c.save 
                            	     end
                            	    

                    redirect_to :action => "shrinkstatus"
      end
    end
  end
  #redirect_to  :action => 'shrink1'
               
  
  
    #render :update do |page|
    #page.alert "Moving To Shrink will end the current service request"
 #page.redirect_to url_for(:controller=>'client', :action=>'updateshrink')   
#end
end



def refresh
 
  #render :partial=>'counter'
   render :update do |page|
     page.replace_html('counter_div',:partial=>'counter')
       page.replace_html('services_div',:partial=>'services')
        page.replace_html('customer_div',:partial=>'customertype')
    end 
  end
  
   def ok
    # change our conditional stop loop variable
    #session[:stop_timer] = true
   render :update do |page|
    #enable the button
     #page << "document.getElementById('aux_div').style.visibility = 'visible'"
   page << "document.getElementById('dialog_div').style.visibility = 'visible'"
    end
  end
  
  
  def cancel
    # change our conditional stop loop variable
    #session[:stop_timer] = true
   render :update do |page|
    #enable the button
     #page << "document.getElementById('aux_div').style.visibility = 'visible'"
   page << "document.getElementById('dialog_div').style.visibility = 'hidden'"
    end
  end                                     

def back
  
render :update do |page|
 page.redirect_to url_for(:controller=>'client', :action=>'transact')   
end


end

def arrived1
@counter=User.find_first(["login=?",@session['user']['login']])

   @a= Transact.find_first(["counterno = ? AND tokenstatus=0",@counter.counterno])


			
                            	@t= Transact.find_all(["tokenstatus=0 and tokenid= ? and counterno<>? ",@a.tokenid,@counter.counterno]) 
                            	
                            	    @t.each do |c| 
                            	    c.tokenstatus=4 
                            	    c.save 
                            	    end
                            	    
                            	
                            	
                            	@x=Transact.find_all(["tokenstatus=0 and tokenid=? and counterno=? and serviceid<>?",@a.tokenid,@counter.counterno,@a.serviceid])
                            	@x.each do |x| 
                            	x.tokenstatus=4 
                            	x.save 
                            	end 
                            	
                            	
                            	if @a.calledtime==nil
                            	calledtime= Time.now().strftime("%H:%M:%S")
                            	call="00:00:00"
                            	else
                            	calledtime=@a.calledtime
                            	call= Time.now().strftime("%H:%M:%S") 
				end
				 
                            	@gwaittime=User.time_diff_in_minutes(@a.generatedtime,Time.now())
                            	

                            	
                            	@update=Transact.update(@a.id,{:call1=>call,:calledtime => calledtime,:waittime => @gwaittime, :login=> @session['user']['login'], :tokenstatus=>2}) 

                            	
                            	
                            	@d=Tokendisplay.find_first(["counterno=?",@a.counterno])
                            	Tokendisplay.update(@d.counterno,{:tokenno=>@a.tokenno})  
render :update do |page|
 page.redirect_to url_for(:controller=>'client', :action=>'transact')   
end
end

def arrived
   @counter=User.find_first(["login=?",@session['user']['login']]) 
  
  
   render :update do |page|
      @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:limit=>1)        
                           
              if(@pendingtoken==nil)
                    #redirect_to :action => "transact"
                    page.redirect_to url_for(:controller=>'client', :action=>'transact')   
                    else
                    if @pendingtoken.calledtime==nil
                            	calledtime= Time.now().strftime("%H:%M:%S")
                            	call="00:00:00"
                            	else
                            	calledtime=@pendingtoken.calledtime
                            	call= Time.now().strftime("%H:%M:%S") 
				           end
                        

  if @pendingtoken.redirecttime==nil
        @gwaittime=User.time_diff_in_minutes(@pendingtoken.generatedtime,Time.now())
        else
        @gwaittime=User.time_diff_in_minutes(@pendingtoken.redirecttime,Time.now())
  end
           #	@gwaittime=User.time_diff_in_minutes(@pendingtoken.generatedtime,Time.now())
                       @update=Transact.update(@pendingtoken.id,{:waittime=>@gwaittime,:call1=>call,:calledtime => calledtime}) 
                       #@t= Transact.find_all(["tokenstatus=0 and tokenid= ? and counterno<>? ",@pendingtoken.tokenid,@counter.counterno]) 
                       #@t= Transact.find_all(["tokenstatus=0 and id<>? and tokenno=?",@pendingtoken.id,@pendingtoken.tokenno]) 
                            	
                            	 # @t.each do |c| 
                            	   # c.tokenstatus=4 
                            	   # c.save 
                                  #end
                    #redirect_to :action => "status"
                    page.redirect_to url_for(:controller=>'client', :action=>'transact')   
                  end
#render :update do |page|
 #page.redirect_to url_for(:controller=>'client', :action=>'transact')   
end
#render :update do |page|
# page.redirect_to url_for(:controller=>'client', :action=>'transact')   
#end
end

def arrivedstatus
@counter=User.find_first(["login=?",@session['user']['login']]) 
  
  
   render :update do |page|
      @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:limit=>1)        
                           
              if(@pendingtoken==nil)
                    #redirect_to :action => "transact"
                    page.redirect_to url_for(:controller=>'client', :action=>'shrink1')   
                    else
                    if @pendingtoken.calledtime==nil
                            	calledtime= Time.now().strftime("%H:%M:%S")
                            	call="00:00:00"
                            	else
                            	calledtime=@pendingtoken.calledtime
                            	call= Time.now().strftime("%H:%M:%S") 
				           end
                        
             if @pendingtoken.redirecttime==nil
               @gwaittime=User.time_diff_in_minutes(@pendingtoken.generatedtime,Time.now())
                    else
                      @gwaittime=User.time_diff_in_minutes(@pendingtoken.redirecttime,Time.now())
                    end

           	#@gwaittime=User.time_diff_in_minutes(@pendingtoken.generatedtime,Time.now())
                       @update=Transact.update(@pendingtoken.id,{:waittime=>@gwaittime,:call1=>call,:calledtime => calledtime}) 
                       #@t= Transact.find_all(["tokenstatus=0 and tokenid= ? and counterno<>? ",@pendingtoken.tokenid,@counter.counterno]) 
                       #@t= Transact.find_all(["tokenstatus=0 and id<>? and tokenno=?",@pendingtoken.id,@pendingtoken.tokenno]) 
                            	
                            	 # @t.each do |c| 
                            	   # c.tokenstatus=4 
                            	   # c.save 
                                  #end
                    #redirect_to :action => "status"
                    page.redirect_to url_for(:controller=>'client', :action=>'shrink1')   
                  end
#render :update do |page|
 #page.redirect_to url_for(:controller=>'client', :action=>'transact')   
end
#render :update do |page|
 #page.redirect_to url_for(:controller=>'client', :action=>'shrink1')   
#end
end

def missed

  @counter=User.find_first(["login=?",@session['user']['login']]) 

   @transact= Transact.find_first(["counterno = ? AND tokenstatus=2",@counter.counterno])
   if @transact.pullcounter!=nil
     @transact.counterno=@transact.pullcounter
     @transact.save
   end
  
   
               @b=Transact.find_all(["tokenid=? and serviceid=?",@transact.tokenid,@transact.serviceid])
            if @transact.missingflag==nil 
               
               if @transact.redirecttime==nil
              p "in missing 2"    
               @gwaittime=User.time_diff_in_minutes(@transact.generatedtime,Time.now())
                  else
                  @gwaittime=User.time_diff_in_minutes(@transact.redirecttime,Time.now())
                end
                
              @b.each do |b|
                         
           

                #@gwaittime=User.time_diff_in_minutes(@transact.generatedtime,Time.now())
                b.waittime=@gwaittime
                b.login=@session['user']['login']
                b.tokenstatus=3
                b.missingflag=1
                b.calledtime=Time.now()
                b.save
               end 
            #@b= Transact.update(@transact.id,{:tokenstatus=> '3',:missingflag=>'1'})
          else
            @b.each do |b|
                          
            # if @transact.redirecttime==nil
              # @gwaittime=User.time_diff_in_minutes(@transact.generatedtime,Time.now())
                #    else
                  #   @gwaittime=User.time_diff_in_minutes(@transact.redirecttime,Time.now())
                    #end

              #@gwaittime=User.time_diff_in_minutes(@transact.generatedtime,Time.now())
                #b.waittime=@gwaittime
                b.login=@session['user']['login']
               b.tokenstatus=3
               b.missingflag=2
               b.call1=Time.now()
               b.save
               end
            #@b= Transact.update(@transact.id,{:tokenstatus=> '3'})
          end
          @c=Transact.find_all(["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
        @c.each do |c|
        c.tokenstatus=0
        c.save
      end 
      
      
     
render :update do |page|
 #modified code under construction
      @counter=User.find_first(["login=?",@session['user']['login']])
      #@pendingtoken =Transact.find_first(["tokenstatus=0 and counterno=?",@counter.counterno])
       @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0 and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:limit=>1)        
              #p "#{pendingtoken}"
              
              if(@pendingtoken==nil)
                    page.redirect_to url_for(:controller=>'client', :action=>'transact')   
                    else
                       @update=Transact.update(@pendingtoken.id,{:tokenstatus=>2}) 
                      #@t= Transact.find_all(["tokenstatus=0 and tokenid= ? and counterno<>? ",@pendingtoken.tokenid,@counter.counterno]) 
                        @t= Transact.find_all(["tokenstatus=0 and id<>? and tokenno=?",@pendingtoken.id,@pendingtoken.tokenno]) 
                            	  @t.each do |c| 
                            	    c.tokenstatus=4 
                            	     c.save 
                            	     end
                    page.redirect_to url_for(:controller=>'client', :action=>'status')   
                    
                  end
                end
                
end



def missedstatus111

  @counter=User.find_first(["login=?",@session['user']['login']]) 

   @transact= Transact.find_first(["counterno = ? AND tokenstatus=2",@counter.counterno])
if @transact.pullcounter!=nil
     @transact.counterno=@transact.pullcounter
     @transact.save
   end
               @b=Transact.find_all(["tokenid=? and serviceid=?",@transact.tokenid,@transact.serviceid])
            if @transact.missingflag==nil 
              @b.each do |b|
                b.tokenstatus=3
                b.missingflag=1
                b.calledtime=Time.now()
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
render :update do |page|
 page.redirect_to url_for(:controller=>'client', :action=>'shrink1')   
end
end




def missedstatus

  @counter=User.find_first(["login=?",@session['user']['login']]) 

   @transact= Transact.find_first(["counterno = ? AND tokenstatus=2",@counter.counterno])
   if @transact.pullcounter!=nil
     @transact.counterno=@transact.pullcounter
     @transact.save
   end
   
               @b=Transact.find_all(["tokenid=? and serviceid=?",@transact.tokenid,@transact.serviceid])
            if @transact.missingflag==nil 
               if @transact.redirecttime==nil
              p "in missing 2"    
               @gwaittime=User.time_diff_in_minutes(@transact.generatedtime,Time.now())
                  else
                  @gwaittime=User.time_diff_in_minutes(@transact.redirecttime,Time.now())
                end
                
              @b.each do |b|
                #@gwaittime=User.time_diff_in_minutes(@transact.generatedtime,Time.now())
                b.waittime=@gwaittime
                b.tokenstatus=3
                b.missingflag=1
                b.calledtime=Time.now()
                b.save
               end 
            #@b= Transact.update(@transact.id,{:tokenstatus=> '3',:missingflag=>'1'})
          else
            @b.each do |b|
              #@gwaittime=User.time_diff_in_minutes(@transact.generatedtime,Time.now())
               # b.waittime=@transact.waittime
               b.tokenstatus=3
               b.missingflag=2
               b.call1=Time.now()
               b.save
               end
            #@b= Transact.update(@transact.id,{:tokenstatus=> '3'})
          end
          @c=Transact.find_all(["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
        @c.each do |c|
        c.tokenstatus=0
        c.save
      end 
      
      #NEW CODE
      render :update do |page|
 #modified code under construction
      @counter=User.find_first(["login=?",@session['user']['login']])
      #@pendingtoken =Transact.find_first(["tokenstatus=0 and counterno=?",@counter.counterno])
       @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0 and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:limit=>1)        
              #p "#{pendingtoken}"
              
              if(@pendingtoken==nil)
                    page.redirect_to url_for(:controller=>'client', :action=>'shrink1')   
                    else
                       @update=Transact.update(@pendingtoken.id,{:tokenstatus=>2}) 
                      #@t= Transact.find_all(["tokenstatus=0 and tokenid= ? and counterno<>? ",@pendingtoken.tokenid,@counter.counterno]) 
                        @t= Transact.find_all(["tokenstatus=0 and id<>? and tokenno=?",@pendingtoken.id,@pendingtoken.tokenno]) 
                            	  @t.each do |c| 
                            	    c.tokenstatus=4 
                            	     c.save 
                            	     end
                    page.redirect_to url_for(:controller=>'client', :action=>'shrinkstatus')   
                    
                  end
                end
      #END
end


end

