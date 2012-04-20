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
       p 'Counter is already logged in'
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
      p "user is logged with #{@c.login}"
      
      User.update(@c.id , {:counterno=> @counter.counterno})
      
       p "User is logged to counter  #{@session['user']['counterno']}"
      flash[:notice] = 'logged in... '
      
      #modified code under construction
      @counter=User.find_first(["login=?",@session['user']['login']])
      pendingtoken =Transact.count(["tokenstatus=0 and counterno=?",@counter.counterno])
      
      p "#{pendingtoken}"
      
      if(pendingtoken>0)
            redirect_to :action => "status"
            else
            redirect_to :action => "transact"
      end
      
      #redirect_to  :controller => 'users',:action => "updatetoken"
      
     
   end
   rescue Exception => exc
    
    STDERR.puts "Error is #{exc.message}"
  end

end

#updatetransact function for updating tokenstatus and showing current token to be served
def updatetransact  
   
    session[:gvar]=0
    session[:b]=0
    session[:flag]=false
     @counter=User.find_first(["login=?",@session['user']['login']])
    @transact= Transact.find_first(["tokenstatus=2 and counterno=?",@counter.counterno])   
    
  # p @transact.login
    if @transact==nil
    
     #modified code under construction
              @counter=User.find_first(["login=?",@session['user']['login']])
              pendingtoken =Transact.find_first(["tokenstatus=0 and counterno=?",@counter.counterno])
              
#p "#{pendingtoken}"
              
              if(pendingtoken!=nil)
                    redirect_to :action => "status"
                    else
                    redirect_to :action => "transact"
      end
      #render :action => 'transact'
        else
    
      if @transact.update_attributes(params[:transact])
        
        #    Wait time = generatedtime-currenttime"   
        @gwaittime=User.time_diff_in_minutes(@transact.generatedtime,Time.now())
       
        # servicedtime= time when service is served"   
        @gservicedtime=Time.now()
        
        # timetaken= servicedtime-calledtime"
        @gtimetaken=User.time_diff_in_minutes(@gservicedtime,@transact.calledtime)
         
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
        @b= Transact.update(@transact.id,{:tokenstatus=> '1',:waittime => @gwaittime, :servicedtime=>@gservicedtime,:timetaken => @gtimetaken}) 
       
       @c=Transact.find_all(["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
        @c.each do |c|
        c.tokenstatus=0
        c.save
        end      
          @t= Transact.delete_all(["tokenstatus=4 and tokenid= ? and counterno<>? and serviceid=?",@transact.tokenid,@counter.counterno,@transact.serviceid])
           
      end
    
    
          #modified code under construction
          @counter=User.find_first(["login=?",@session['user']['login']])
          pendingtoken =Transact.count(["tokenstatus=0 and counterno=?",@counter.counterno])
          
          p "#{pendingtoken}"
          
          if(pendingtoken>0)
                redirect_to :action => "status"
                else
                redirect_to :action => "transact"
      end
        #redirect_to  :action => 'transact'
           
      else
        p "redirecting"
      render  :action => 'transact'
    
    end
    end
  end
  
def shrinksave_pause
@counter=User.find_first(["login=?",@session['user']['login']]) 
@transact= Transact.find_first(["pauseflag=1 and counterno=?",@counter.counterno])    
#@reason=params[:auxreason][:reasons]
@reason='Lunch'
@b= Pause.update(@transact.counterno,{:reason=> 'Lunch'})
p "Reason selected was #{@reason}"

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
     
     STDERR.puts "Error is #{exc.message}"
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
        @transact1= Transact.find_all(["tokenstatus=4 and tokenid= ?  and counterno<>?",@transact.tokenid,@counter.counterno])   
        p "Rows = #{@transact1}"
       
        if @transact1==nil
        
       
        else
        #updating tokenstatus to be 0 for same token pending at others counters
        @transact1.each do |c|
        c.tokenstatus=0
        c.save
        p 'record updated'
        end
  
       # @t= Transact.update(["tokenstatus=0 and tokenid= ? and counterno<>?",@transact.tokenid,$counterno])
       # page.redirect_to url_for(:controller=>'client', :action=>'updatetransact')
        #page.form.reset :form1
        redirect_to  :action => 'updatetransact'
        end
      
end
# End if Redirect method
def redirecting
 render :update do |page|
      # page.replace_html 'aux_div', 'Please wait releasing pause ....'
    page.redirect_to url_for(:controller=>'client', :action=>'tokenredirect')
    #page.form.reset :form1
    end
end

def password 
   @user = @session['user']
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
            end
          end 
          #page.redirect_to url_for(:controller=>"users", :action => "change_password")
          #redirect_back_or_default :controller => "client", :action => "transact" 
        end
    #end
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
p "tokenid=#{params[:id]}"  
@counter=User.find_first(["login=?",@session['user']['login']]) 
@session['calltoken'] = Transact.find(params[:id])
 @transact2= Transact.find_first(["tokenno=? and tokenstatus=0",@session['calltoken']['tokenno']])   
      if @transact2!=nil
       #@transact2.tokenstatus=0
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
  p 'value is null for reasons'
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
    #page.form.reset :form1
  end

end

 rescue Exception => exc
    
    STDERR.puts "Error is #{exc.message}"
  end
end


def updateshrink
 @counter=User.find_first(["login=?",@session['user']['login']])
  @transact= Transact.find_first(["tokenstatus=2 and counterno=?",@counter.counterno])       
    if @transact==nil 
      #render :action => 'shrink1'
    else
    if @transact.update_attributes(params[:shrink1])
       
        #    Wait time = generatedtime-currenttime"   
        @gwaittime=User.time_diff_in_minutes(@transact.generatedtime,Time.now())
       
        # servicedtime= time when service is served"   
        @gservicedtime=Time.now()
        
        # timetaken= servicedtime-calledtime"
        @gtimetaken=User.time_diff_in_minutes(@gservicedtime,@transact.calledtime)
         
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
        
        @b= Transact.update(@transact.id,{:tokenstatus=> '1',:pauseflag=>1,:pausetime=>Time.now, :servicedtime=>@gservicedtime,:timetaken => @gtimetaken}) 
         
           @t= Transact.delete_all(["tokenstatus=1 and tokenid= ? and counterno<>?",@transact.tokenid,@counter.counterno])
          
      end
    end
  end
  redirect_to  :action => 'shrink1'
    #render :update do |page|
    #page.alert "Moving To Shrink will end the current service request"
 #page.redirect_to url_for(:controller=>'client', :action=>'updateshrink')   
#end
end



def refresh
 
  #render :partial=>'counter'
   render :update do |page|
     page.replace_html('counter_div',:partial=>'counter')
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
   p 'fgfg'
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
render :update do |page|
 page.redirect_to url_for(:controller=>'client', :action=>'transact')   
end
end


def missed

  @counter=User.find_first(["login=?",@session['user']['login']]) 

   @transact= Transact.find_first(["counterno = ? AND tokenstatus=2",@counter.counterno])

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
 page.redirect_to url_for(:controller=>'client', :action=>'transact')   
end
end

end

