#An unpublished work of Sprylogic Technologies Ltd. 
# © Copyright Sprylogic Technologies Ltd. 2011. All rights reserved 
require 'fileutils'
class ClientController < ApplicationController
      before_filter :login_required  
      def updateteller
      begin
           session[:count]=0
           session[:timer]=false
           session[:flag]=false
           @counterid=params[:updateteller][:counterno] 
           session[:logincounter]=params[:updateteller][:counterno]
           @counter=Counter.find(:first,:conditions=>["counterno = ? and loginstatus='N' and counterstatus=1",@counterid])
           if @counter==nil # checks for the login status of the counter no selected by the user.
              flash[:notice] = 'Counter is already logged in...'
              @message  = "Wrong teller"
           else
              @b= Counter.update(@counter.id,{:loginstatus=> 'Y'}) 
              #update counterno in user table
              @c=User.find(:first,:conditions=>["login=?",@session['user']])
              User.update(@c.id , {:counterno=> @counter.counterno})  
              flash[:notice] = 'logged in... '
              @counter=User.find(:first,:conditions=>["login=?",@session['user']])
              # checks whether the user has any pending tokens if yes, he is directed towards the status screen, else, to the transact screen.
              Transact.transaction do
                       @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0  and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:lock=>'LOCK IN SHARE MODE')        
                       if(@pendingtoken==nil)
                          redirect_to :action => "transact"
                       else
                          @asd=@session['user']
                          @update=Transact.update(@pendingtoken.id,{:login=>"#{@asd}",:tokenstatus=>2 })
                          @update.inspect
                          @t= Transact.find(:all,:conditions=>["tokenstatus=0 and id<>? and tokenno=?",@update.id,@update.tokenno],:lock=>'LOCK IN SHARE MODE')
                          @t.each do |c| 
                             c.tokenstatus=4 
                             c.save 
                          end
                          redirect_to :action => "status"
                       end
              end  
           end
       rescue Exception => exc    
end

end

#updatetransact function for updating tokenstatus and showing current token to be served
def updatetransact 

begin
  session[:gvar]=0
  session[:b]=0
  session[:flag]=false
  
  @counter=User.find(:first,:conditions=>["login=?",@session['user']])
  @transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno])
#checks if the user is serving any token currently
    if @transact==nil
    @counter=User.find(:first,:conditions=>["login=?",@session['user']])
    Transact.transaction do
      # checks whether the user has any pending tokens
      @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0  and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:lock=>'LOCK IN SHARE MODE') 
      if(@pendingtoken==nil)
        redirect_to :action => "transact" # if no, redirect to transacts, if yes, update tokenstatus=2 for the counter serving the token and tokenstatus=4 for rest all counters where the token is assigned
      else
    
        @update=Transact.update(@pendingtoken.id,{:login=>"#{@asd}",:tokenstatus=>2})      
        @t= Transact.find(:all,:conditions=>["tokenstatus=0 and id<>? and tokenno=?",@update.id,@update.tokenno],:lock=>'LOCK IN SHARE MODE')
        @t.each do |c| 
          c.tokenstatus=4 
          c.save 
      end
      
        redirect_to :action => "status"
      end
    end
  else
    # updating transacts table after serving the current token
    if @transact.update_attributes(params[:transact]) 
      @gservicedtime=Time.now()
      if @transact.missingflag==nil
        @gtimetaken=User.time_diff_in_minutes(@transact.calledtime,Time.now())
      else
       @gtimetaken=User.time_diff_in_minutes(@transact.call1,Time.now())
      end
      if (params[:missed]=='on') #if the customer is missing update tokenstatus=3 
        @b=Transact.find(:all,:conditions=>["tokenid=? and serviceid=?",@transact.tokenid,@transact.serviceid])
        if @transact.missingflag==nil 
          @b.each do |b|
            b.tokenstatus=3
            b.missingflag=1
            b.save
          end 
        else
          @b.each do |b|
            b.tokenstatus=3
            b.missingflag=2
            b.save
          end
        end
        @c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
        @c.each do |c|
          c.tokenstatus=0
          c.save
        end    
      else
        # after the token is served update the tokenstatus = 1 for the counter on which it was served and delete the rows with tokenstatus=4 for the same token with same serviceid on other counters
        
	    @transact.id
	    @gservicedtime
	    @gtimetaken
	    
	    @transact.tokenid
	    @transact.serviceid
	   
	   @service=Service.find(:first, :conditions => ["serviceid=?", @transact.serviceid])
	    @service.thresholdtime.strftime("%H:%M:%S") #=='00:25:00'
		#@b= Transact.update(@transact.id,{:login=>@@session['user']['login'], :tokenstatus=> '1',:servicedtime=>@gservicedtime,:timetaken => @gtimetaken})	   
        
         @asd=@session['user']
         
        @b= Transact.update(@transact.id,{:login=>"#{@asd}", :tokenstatus=> '1',:servicedtime=>@gservicedtime,:timetaken => @gtimetaken,:flag=>'N'})	   
        
        
# ***************************** New Score card Generation Logic= 10-(timetaken/threshodtime) *10  ********************
# *********------------------------>> Calculted 2010-12-14 <<------------------------------***************************   
		 @a1=@transact.id
         @a2=@gtimetaken
         @a3=@transact.serviceid
         @a4=@service.thresholdtime.strftime("%H:%M:%S")
	                
         
          @t=Transact.find_by_sql("select t.id as id, 10-(time_to_sec('#{@a2}')/time_to_sec('#{@a4}')) *10 as score1
                              from transacts t
                              where serviceid='#{@a3}' and id=#{@a1}")
         
             
           @t.each do |d|
             " #{d.id} #{@score=d.score1}" 
               if @score.to_i > 0
                   
                   @b= Transact.update(d.id,{:score =>"%.2f " % @score})
               else
                   @b= Transact.update(d.id,{:score => 0})
                   
               end     
             
              
          end	
# *********------------------------>> The end <<------------------------------***************************           
        
        @c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
        @c.each do |c|
          c.tokenstatus=0
          c.save
        end      
        @t= Transact.delete_all(["tokenstatus=4 and tokenid= ? and counterno<>? and serviceid=?",@transact.tokenid,@counter.counterno,@transact.serviceid])
      end

      #@counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
      @counter=User.find(:first,:conditions=>["login=?",@session['user']])
      @asd=@session['user']
      Transact.transaction do           
        @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0 and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:lock=>'LOCK IN SHARE MODE')   
        if(@pendingtoken==nil)
          redirect_to :action => "transact"
        else
          @update=Transact.update(@pendingtoken.id,{:login=>"#{@asd}",:tokenstatus=>2}) 
          @t= Transact.find(:all,:conditions=>["tokenstatus=0 and id<>? and tokenno=?",@update.id,@update.tokenno],:lock=>'LOCK IN SHARE MODE')  	
          @t.each do |c| 
            c.tokenstatus=4 
            c.save 
          end
          redirect_to :action => "status"
        end
      end
    else
      render  :action => 'transact'
    end
end

rescue Exception => exc
  redirect_to :action => "transact"
end
end
  
  
def updatetransacthold
  # same as updatetransact
begin
  session[:gvar]=0
  session[:b]=0
  session[:flag]=false
  @counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
  @transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno])   
  if @transact==nil
    @counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
    Transact.transaction do
      @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0  and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:lock=>'LOCK IN SHARE MODE') 
      if(@pendingtoken==nil)
        redirect_to :action => "transact"
      else
        @update=Transact.update(@pendingtoken.id,{:tokenstatus=>2})      
        @t= Transact.find(:all,:conditions=>["tokenstatus=0 and id<>? and tokenno=?",@update.id,@update.tokenno],:lock=>'LOCK IN SHARE MODE')
        @t.each do |c| 
          c.tokenstatus=4 
          c.save 
        end
        redirect_to :action => "status"
      end
    end
  else
    if @transact.update_attributes(params[:transact])
      @gservicedtime=Time.now()
      if @transact.missingflag==nil
        @gtimetaken=User.time_diff_in_minutes(@transact.calledtime,Time.now())
      else
       @gtimetaken=User.time_diff_in_minutes(@transact.call1,Time.now())
      end
      #checking whether the missed is clicked or not if yes then update tokenstatus=3 else tokenstatus=1
      if (params[:missed]=='on')
        @b=Transact.find(:all,:conditions=>["tokenid=? and serviceid=?",@transact.tokenid,@transact.serviceid])
        if @transact.missingflag==nil 
          @b.each do |b|
            b.tokenstatus=3
            b.missingflag=1
            b.save
          end 
        else
          @b.each do |b|
            b.tokenstatus=3
            b.missingflag=2
            b.save
          end
        end
        @c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
        @c.each do |c|
          c.tokenstatus=0
          c.save
        end    
      else
        @b= Transact.update(@transact.id,{:login=>@@session['user']['login'], :tokenstatus=> '1', :servicedtime=>@gservicedtime,:timetaken => @gtimetaken}) 
        @c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
        @c.each do |c|
          c.tokenstatus=0
          c.save
        end      
        @t= Transact.delete_all(["tokenstatus=4 and tokenid= ? and counterno<>? and serviceid=?",@transact.tokenid,@counter.counterno,@transact.serviceid])
      end
      @counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
      Transact.transaction do           
        @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0 and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:lock=>'LOCK IN SHARE MODE')   
        if(@pendingtoken==nil)
          redirect_to :action => "transact"
        else
        @update=Transact.update(@pendingtoken.id,{:tokenstatus=>2}) 
        @t= Transact.find(:all,:conditions=>["tokenstatus=0 and id<>? and tokenno=?",@update.id,@update.tokenno],:lock=>'LOCK IN SHARE MODE')  	
        @t.each do |c| 
          c.tokenstatus=4 
          c.save 
        end
        redirect_to :action => "status"
      end
    end
    else
      render  :action => 'transact'
    end
  end
rescue Exception => exc
redirect_to :action => "transact"
end
  end
  
def shrinksave_pause
@counter=User.find(:first,:conditions=>["login=?",@session['user']]) 
@transact= Transact.find(:first,:conditions=>["pauseflag=1 and counterno=?",@counter.counterno])    
@reason='Lunch'
@b= Pause.update(@transact.counterno,{:reason=> 'Lunch'})
end

def time
  begin   
    @counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
    @transact= Transact.find(:first,:conditions=>[" counterno=?  ",@counter.counterno])     
    session[:gvar]=session[:gvar]+5
    if session[:gvar]>60
      session[:b]=session[:b]+1
      session[:gvar]=0
      @c="00:0#{session[:b]}:#{session[:gvar]}"
      @time=Service.find(:first,:conditions=>["serviceid=? and thresholdtime=?",@transact.serviceid,@c])
      if (@time==nil and session[:flag]==false)
        render :text=> " 00:0#{session[:b]}:#{session[:gvar]}" 
      elsif session[:flag]==true
        @p=render :text=> '<font color=red size=4><b>'+"00:0#{session[:b]}:#{session[:gvar]}" +'</b></font>'
      else
        @p=render :text=> '<font color=red size=4><b>'+"00:0#{session[:b]}:#{session[:gvar]}" +'</b></font>'
        session[:flag]=true
      end    
    else      
      @f="00:0#{session[:b]}:#{session[:gvar]}"  
      @time=Service.find(:first,:conditions=>["serviceid=? and thresholdtime=?",@transact.serviceid,@f])
      if (@time==nil and session[:flag]==false)
        render :text=> " 00:0#{session[:b]}:#{session[:gvar]}" 
      elsif session[:flag]==true
        @p=render :text=> '<font color=red size=4><b>'+"00:0#{session[:b]}:#{session[:gvar]}" +'</b></font>'
      else
        @p=render :text=> '<font color=red size=4><b>'+"00:0#{session[:b]}:#{session[:gvar]}" +'</b></font>'
        session[:flag]=true
      end
    end
  rescue Exception => exc
  end  
end

#function for retrieving current counter logged in
def token
    @session['token'] = Counter.find(params[:id])
end

#missing function for redirecting to missing view
def missing
  render :update do |page|
    page.redirect_to url_for(:controller=>'client', :action=>'displaymissing')
  end
end
 
#Redirect Method
def redirect
#redirecting the current token to onther counter by updating its token status=0 and who is redirecting as 5
@counter=User.find(:first,:conditions=>["login=?",@session['user']])
@transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno])   
@b= Transact.update(@transact.id,{:tokenstatus=> '5'}) 
@counterno=params[:id].to_i

@session['redirecttoken'] =Counter.find(:first,:select=>"counterno",:conditions=>["counterno=?","#{@counterno}"])


@transact2=Transact.new
@transact2.tokenno=@transact.tokenno
@transact2.tokenid=@transact.tokenid
@transact2.generatedtime=@transact.generatedtime
@transact2.transdate=@transact.transdate
@transact2.serviceid=@transact.serviceid
@transact2.ctypeid=@transact.ctypeid
@transact2.counterno=@session['redirecttoken'].counterno
@transact2.redirecttime=Time.now()
@transact2.tokenstatus=0
@transact2.save
#code for releasing token for other services
@c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
@c.each do |c|
    c.tokenstatus=0
    c.save
  end      
@t= Transact.delete_all(["tokenstatus=4 and tokenid= ? and counterno<>? and serviceid=?",@transact.tokenid,@counter.counterno,@transact.serviceid])
redirect_to  :action => 'updatetransact'
end
    
    
    
def pulltraffic
  render :update do |page|    
    page.redirect_to url_for(:controller=>'client', :action=>'calltraffic')   
  end
end


# End if Redirect method
def callmissing
@counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
@transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno])  
if @transact==nil
    render :update do |page|        
      page.redirect_to url_for(:controller=>'client', :action=>'calldisplaymissing')        
    end     
  else
    begin
      session[:gvar]=0
      session[:b]=0
      session[:flag]=false
      @counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
      @transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno]) 
      if @transact==nil
        render :update do |page|        
          page.redirect_to url_for(:controller=>'client', :action=>'calldisplaymissing')        
        end         
      else    
        if @transact.update_attributes(params[:transact])
          @gservicedtime=Time.now()
          if @transact.missingflag==nil
            @gtimetaken=User.time_diff_in_minutes(@transact.calledtime,Time.now())
          else
            @gtimetaken=User.time_diff_in_minutes(@transact.call1,Time.now())
          end
          if (params[:missed]=='on')
            @b=Transact.find(:all,:conditions=>["tokenid=? and serviceid=?",@transact.tokenid,@transact.serviceid])
            if @transact.missingflag==nil 
              @b.each do |b|
                b.tokenstatus=3
                b.missingflag=1
                b.save
              end 
            else
              @b.each do |b|
                b.tokenstatus=3
                b.missingflag=2
                b.save
              end
            end
            @c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
            @c.each do |c|
              c.tokenstatus=0
              c.save
            end    
          else
            @b= Transact.update(@transact.id,{:login=>@@session['user']['login'], :tokenstatus=> '1', :servicedtime=>@gservicedtime,:timetaken => @gtimetaken}) 
            @c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
            @c.each do |c|
              c.tokenstatus=0
              c.save
            end      
            @t= Transact.delete_all(["tokenstatus=4 and tokenid= ? and counterno<>? and serviceid=?",@transact.tokenid,@counter.counterno,@transact.serviceid])
          end
          @counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
          render :update do |page|        
            page.redirect_to url_for(:controller=>'client', :action=>'calldisplaymissing')        
          end  
        else
          render :update do |page|        
            page.redirect_to url_for(:controller=>'client', :action=>'calldisplaymissing')        
          end  
        end
      end
    rescue Exception => exc
      render :update do |page|        
        page.redirect_to url_for(:controller=>'client', :action=>'calldisplaymissing')        
      end  
    end      
  end 
end



#old Redirect Method for redirecting token to counter having similar service mapped
def redirect111
#redirecting the current token to onther counter by updating its token status=0 and who is redirecting as 5
@counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
@transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno])   
@b= Transact.update(@transact.id,{:tokenstatus=> '5'}) 
@session['redirecttoken'] = Transact.find(params[:id])
@transact2= Transact.find(:first,:conditions=>["counterno=? and tokenno=? and tokenstatus=4",@session['redirecttoken']['counterno'],@session['redirecttoken']['tokenno']])   
  if @transact2!=nil
    @transact2.redirecttime=Time.now()
    @transact2.tokenstatus=0
    @transact2.save
    redirect_to  :action => 'updatetransact'
  end
end
# End if Redirect method


def redirecting
 render :update do |page|
    page.redirect_to url_for(:controller=>'client', :action=>'tokenredirect')
  end
end


def password_changed
end


def pass_change
render :update do |page|
  page.redirect_to url_for(:controller=>'client', :action=>'transact')
end
end

def password 
   @counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
     @counter.counterno
   @user = @@session['user']
    @params['new_password']
    case @request.method
      when :post   
        if @params['old_password'].blank? 
          @msg= 'Please enter your old Password!'
        else
            unless  @user.password_check?(@params['old_password']) 
              @msg= 'You have introduced a wrong old password!'  
            else              
                if @params['new_password'].blank? 
                  @msg= 'Please enter your new Password !'
                else
                    unless @user.validate_password(@params['new_password'])
                       @msg= 'Password should contain atleast one integer,one alphabet,one special characters from 20 to 7E ascii values and minimum of 8 and maximum of 40 cahracters long .'
                    else                   
                        if @params['new_password_confirmation'].blank?
                          @msg= 'Please enter your Password again for confirmation!' 
                        else
                            unless @params['new_password'] == @params['new_password_confirmation']
                               @msg = 'Your new password and password confirmation dont match!'
                            else   
                               @msg = 'Your password was changed successfully!' if @user.change_password(@params['new_password'])
                               @counter.counterno
                                redirect_to :controller => 'client', :action=>'transact'
                               @counter.counterno
                            end   
                        end
                    end   
                end
            end
        end
    end
end  



def passwordold
@user=User.find(@@session['user'])
  case @request.method
    when :post   
      unless @user.password_check?(@params['old_password'])        
        @msg = 'You have introduced a wrong old password!'
      else
      unless @params['new_password'] == @params['new_password_confirmation']
        @msg = 'Your new password and password confirmation dont match!'
      else
        @msg = 'Your password was changed successfully!' if @user.change_password(@params['new_password'])
      end
    end 
  end
end
  
def password1 
@user=User.find(@@session['user'])
if request.post? 
  if User.authenticate(@user.login,@params['old_password']) == @user 
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
@transact2= Transact.find(:first,:conditions=>["tokenno=?",$tokenno])   
@transact2.tokenstatus=0
@transact2.save
render :update do |page|
  page.redirect_to url_for(:controller=>'client', :action=>'updatetransact')
end
end


#function for tokenpulling
def calltoken
@counter=User.find(:first,:conditions=>["login=?",@session['user']]) 
@session['calltoken'] = Transact.find(params[:id])
@transact2= Transact.find(:first,:conditions=>["tokenno=? and id=? and tokenstatus=0",@session['calltoken']['tokenno'],@session['calltoken']['id']])   
  if @transact2!=nil
    @transact2.pullcounter=@transact2.counterno
    @transact2.counterno=@counter.counterno
    @transact2.save
  end
  redirect_to  :action => 'updatetransact'
end

def callmissingtoken
  begin
    @t=Transact.find_by_sql("update transacts set tokenstatus=0 where id=#{params[:id]}")
  rescue
  end
  redirect_to  :action => 'updatetransact'
end

def callholdtoken
  begin
     @t=Transact.find_by_sql("update transacts set tokenstatus=0 where id=#{params[:id]}")
  rescue
  end
     redirect_to  :action => 'updatetransact'
  end
  


def save_pause
 begin
   @counter=User.find_first(["login=?",@session['user']]) 
   params[:transact][:reasons]
   render :update do |page|
if params[:transact][:reasons]==""
     @msg = 'Please select pause time!'
     page.alert "Please select pause reason!"
else
     @transact= Transact.find_first(["pauseflag=1 and counterno=?",@counter.counterno])    
     @transact.reasons=params[:transact][:reasons]
     @transact.save
     @pause= Pausedetail.find_first(["pflag=1 and counterno=?",@counter.counterno])    
     @pause.reason=params[:transact][:reasons]
     @pause.save
     page.replace_html 'aux_div', 'You are in pause mode ....'
     page << "document.getElementById('Release').disabled = false;"
     page << "document.getElementById('show').style.visibility = 'visible'"
     page << "document.getElementById('pausetime').style.visibility = 'visible'"
  end
end

 rescue Exception => exc
       #STDERR.puts "Error is #{exc.message}"
 end
end


def updateshrink
=begin    
begin
@counter=User.find(:first,:conditions=>["login=?",@session['user']])
@transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno])       
   if @transact==nil 
       @counter=User.find(:first,:conditions=>["login=?",@session['user']])
        Transact.transaction do
               @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0  and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:lock=>'LOCK IN SHARE MODE')    
               if(@pendingtoken==nil)
                  redirect_to :action => "shrink1"
               else
                  @update=Transact.update(@pendingtoken.id,{:tokenstatus=>2}) 
                  @t= Transact.find(:all,:conditions=>["tokenstatus=0 and id<>? and tokenno=?",@update.id,@update.tokenno],:lock=>'LOCK IN SHARE MODE')      	
                  @t.each do |c| 
                     c.tokenstatus=4 
                     c.save 
                  end
                redirect_to :action => "shrinkstatus"
                end
        end    
    else
        if @transact.update_attributes(params[:transact])
           @gservicedtime=Time.now()
           @gtimetaken=User.time_diff_in_minutes(@transact.calledtime,Time.now())
           if (params[:missed]=='on')
               @t= Transact.find(:all,:conditions=>["tokenid= ?",@transact.tokenid])
               #updating tokenstatus to be 1 for same token pending at others counters
               @t.each do |c| 
                  c.tokenstatus=3
                  c.calledtime=@transact.calledtime
                  c.save
               end 
           else
               @login=@session['user']
               @b= Transact.update(@transact.id,{:tokenstatus=> '1',:servicedtime=>@gservicedtime,:timetaken => @gtimetaken,:login=>"#{@login}"}) 
               @t= Transact.delete_all(["tokenstatus=1 and tokenid= ? and counterno<>?",@transact.tokenid,@counter.counterno])
            end
      @counter=User.find(:first,:conditions=>["login=?",@session['user']])
      Trasnact.transaction do
        @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0  and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:lock=>'LOCK IN SHARE MODE')  
        if(@pendingtoken==nil)
          redirect_to :action => "shrink1"
        else
          @update=Transact.update(@pendingtoken.id,{:tokenstatus=>2}) 
          @t= Transact.find(:all,:conditions=>["tokenstatus=0 and id<>? and tokenno=?",@update.id,@update.tokenno],:lock=>'LOCK IN SHARE MODE')     	
          @t.each do |c| 
            c.tokenstatus=4 
            c.save 
          end
          redirect_to :action => "shrinkstatus"
        end
      end
    end
  end
rescue Exception => exc
  redirect_to :action => "shrink1"
end
=end
begin
  session[:gvar]=0
  session[:b]=0
  session[:flag]=false
  @counter=User.find(:first,:conditions=>["login=?",@session['user']])
  @transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno])
#checks if the user is serving any token currently
    if @transact==nil
    @counter=User.find(:first,:conditions=>["login=?",@session['user']])
    Transact.transaction do
      # checks whether the user has any pending tokens
      @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0  and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:lock=>'LOCK IN SHARE MODE') 
      if(@pendingtoken==nil)
        redirect_to :action => "shrink1" # if no, redirect to transacts, if yes, update tokenstatus=2 for the counter serving the token and tokenstatus=4 for rest all counters where the token is assigned
      else
    
        @update=Transact.update(@pendingtoken.id,{:login=>"#{@asd}",:tokenstatus=>2})      
        @t= Transact.find(:all,:conditions=>["tokenstatus=0 and id<>? and tokenno=?",@update.id,@update.tokenno],:lock=>'LOCK IN SHARE MODE')
        @t.each do |c| 
          c.tokenstatus=4 
          c.save 
      end
      
         redirect_to :action => "shrinkstatus"
      end
    end
  else
    # updating transacts table after serving the current token
    if @transact.update_attributes(params[:transact]) 
      @gservicedtime=Time.now()
      if @transact.missingflag==nil
        @gtimetaken=User.time_diff_in_minutes(@transact.calledtime,Time.now())
      else
       @gtimetaken=User.time_diff_in_minutes(@transact.call1,Time.now())
      end
      if (params[:missed]=='on') #if the customer is missing update tokenstatus=3 
        @b=Transact.find(:all,:conditions=>["tokenid=? and serviceid=?",@transact.tokenid,@transact.serviceid])
        if @transact.missingflag==nil 
          @b.each do |b|
            b.tokenstatus=3
            b.missingflag=1
            b.save
          end 
        else
          @b.each do |b|
            b.tokenstatus=3
            b.missingflag=2
            b.save
          end
        end
        @c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
        @c.each do |c|
          c.tokenstatus=0
          c.save
        end    
      else
        # after the token is served update the tokenstatus = 1 for the counter on which it was served and delete the rows with tokenstatus=4 for the same token with same serviceid on other counters
        
	    @transact.id
	    @gservicedtime
	    @gtimetaken
	   
	    @transact.tokenid
	    @transact.serviceid
	   
	   @service=Service.find(:first, :conditions => ["serviceid=?", @transact.serviceid])
	    @service.thresholdtime.strftime("%H:%M:%S") #=='00:25:00'
		#@b= Transact.update(@transact.id,{:login=>@@session['user']['login'], :tokenstatus=> '1',:servicedtime=>@gservicedtime,:timetaken => @gtimetaken})	   
        
         @asd=@session['user']
        @b= Transact.update(@transact.id,{:login=>"#{@asd}", :tokenstatus=> '1',:servicedtime=>@gservicedtime,:timetaken => @gtimetaken})	   
        
        
# ***************************** New Score card Generation Logic= 10-(timetaken/threshodtime) *10  ********************
# *********------------------------>> Calculted 2010-12-14 <<------------------------------***************************   
		 @a1=@transact.id
         @a2=@gtimetaken
         @a3=@transact.serviceid
         @a4=@service.thresholdtime.strftime("%H:%M:%S")

         
          @t=Transact.find_by_sql("select t.id as id, 10-(time_to_sec('#{@a2}')/time_to_sec('#{@a4}')) *10 as score1
                              from transacts t
                              where serviceid='#{@a3}' and id=#{@a1}")
         
              
           @t.each do |d|
            d.id #{@score=d.score1}****************" 
               if @score.to_i > 0
                   
                   @b= Transact.update(d.id,{:score =>"%.2f " % @score})
               else
                   @b= Transact.update(d.id,{:score => 0})
                   
               end     
             
              
          end	
# *********------------------------>> The end <<------------------------------***************************           
        
        @c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
        @c.each do |c|
          c.tokenstatus=0
          c.save
        end      
        @t= Transact.delete_all(["tokenstatus=4 and tokenid= ? and counterno<>? and serviceid=?",@transact.tokenid,@counter.counterno,@transact.serviceid])
      end

      #@counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
      @counter=User.find(:first,:conditions=>["login=?",@session['user']])
      @asd=@session['user']
      Transact.transaction do           
        @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0 and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:lock=>'LOCK IN SHARE MODE')   
        if(@pendingtoken==nil)
           redirect_to :action => "shrink1"
        else
          @update=Transact.update(@pendingtoken.id,{:login=>"#{@asd}",:tokenstatus=>2}) 
          @t= Transact.find(:all,:conditions=>["tokenstatus=0 and id<>? and tokenno=?",@update.id,@update.tokenno],:lock=>'LOCK IN SHARE MODE')  	
          @t.each do |c| 
            c.tokenstatus=4 
            c.save 
          end
           redirect_to :action => "shrinkstatus"
        end
      end
    else
      redirect_to :action => "shrink1"
    end
end

rescue Exception => exc
  redirect_to :action => "shrink1"
end
end



def refresh
  render :update do |page|
    page.replace_html('counter_div',:partial=>'counter')
    page.replace_html('services_div',:partial=>'services')
    page.replace_html('customer_div',:partial=>'customertype')
  end 
end
  
def ok
  # change our conditional stop loop variable
  render :update do |page|
    #enable the button
    page << "document.getElementById('dialog_div').style.visibility = 'visible'"
  end
end
  
  
def cancel
# change our conditional stop loop variable
render :update do |page|
  #enable the button
  page << "document.getElementById('dialog_div').style.visibility = 'hidden'"
end
end                                     


def back
render :update do |page|
 page.redirect_to url_for(:controller=>'client', :action=>'transact')   
end
end


def arrived1
begin
  @counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
  @a= Transact.find(:first,:conditions=>["counterno = ? AND tokenstatus=0",@counter.counterno])
  @t= Transact.find(:all,:conditions=>["tokenstatus=0 and tokenid= ? and counterno<>? ",@a.tokenid,@counter.counterno]) 
  @t.each do |c| 
    c.tokenstatus=4 
    c.save 
  end
  @x=Transact.find(:all,:conditions=>["tokenstatus=0 and tokenid=? and counterno=? and serviceid<>?",@a.tokenid,@counter.counterno,@a.serviceid])
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
  @update=Transact.update(@a.id,{:call1=>call,:calledtime => calledtime,:waittime => @gwaittime, :login=> @@session['user']['login'], :tokenstatus=>2}) 
  @d=Tokendisplay.find(:first,:conditions=>["counterno=?",@a.counterno])
  Tokendisplay.update(@d.counterno,{:tokenno=>@a.tokenno})  
  render :update do |page|
    page.redirect_to url_for(:controller=>'client', :action=>'transact')   
  end
rescue Exception => exw
    a=Dir.pwd()
    if File.directory?("home/ErrorLogs")
      f="home/ErrorLogs"
      Dir.chdir(f)
      fp=File.new("Error.log","a")
      fp.write(Time.now.to_s+"-"+exw.message)
      fp.write("\n")
      fp.close()
      Dir.chdir(a)
    else
      e="C:/"
      Dir.chdir(e)
      FileUtils.mkdir_p 'ErrorLogs'
      f="home/ErrorLogs"
      Dir.chdir(f)
      fp=File.new("Error.log","a")
      fp.write(Time.now.to_s+"-"+exw.message)
      fp.write("\n")
      fp.close()
      Dir.chdir(a)
    end
     exw.message
  end
end


def arrived
begin
    #@counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
     @counter=User.find(:first,:conditions=>["login=?",@session['user']])
     @x=Tokendisplay.update(@counter.counterno,{:tokenno=>'0000'}) 
     render :update do |page|
             @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:limit=>1)        
             if(@pendingtoken==nil)
                page.redirect_to url_for(:controller=>'client', :action=>'transact')   
             else
                if @pendingtoken.calledtime.strftime("%H:%M:%S") !=Time.parse('00:00:00').strftime("%H:%M:%S")
                    calledtime=@pendingtoken.calledtime
                    call= Time.now().strftime("%H:%M:%S") 
                else
                    calledtime= Time.now().strftime("%H:%M:%S")
                    call="00:00:00"
                 end
                 begin 
                    if @pendingtoken.redirecttime==nil
                       @gwaittime=User.time_diff_in_minutes(@pendingtoken.generatedtime,Time.now())
                    else
                       @gwaittime=User.time_diff_in_minutes(@pendingtoken.generatedtime,Time.now())
                    end
                 rescue Exception => ex
                        ex.message
                 end
                 #@asd=@session['user']
                 @update=Transact.update(@pendingtoken.id,{:waittime=>@gwaittime,:call1=>call,:calledtime => calledtime}) 
                 page.redirect_to url_for(:controller=>'client', :action=>'transact')   
             end
      end
rescue Exception => exw
       a=Dir.pwd()
       if File.directory?("home/ErrorLogs")
          f="home/ErrorLogs"
          Dir.chdir(f)
          fp=File.new("Error.log","a")
          fp.write(Time.now.to_s+"-"+exw.message)
          fp.write("\n")
          fp.close()
          Dir.chdir(a)
       else
          e="/home"
          Dir.chdir(e)
          FileUtils.mkdir_p 'ErrorLogs'
          f="home/ErrorLogs"
          Dir.chdir(f)
          fp=File.new("Error.log","a")
          fp.write(Time.now.to_s+"-"+exw.message)
          fp.write("\n")
          fp.close()
          Dir.chdir(a)
       end
end
end



def arrivedstatus
    
begin
@counter=User.find(:first,:conditions=>["login=?",@session['user']]) 
@x=Tokendisplay.update(@counter.counterno,{:tokenno=>'0000'}) 
render :update do |page|
    @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:limit=>1)        
    if(@pendingtoken==nil)
      #redirect_to :action => "transact"
      page.redirect_to url_for(:controller=>'client', :action=>'shrink1')   
    else
      if @pendingtoken.calledtime.strftime("%H:%M:%S") !=Time.parse('00:00:00').strftime("%H:%M:%S")
        calledtime=@pendingtoken.calledtime
        call= Time.now().strftime("%H:%M:%S") 
      else
        calledtime= Time.now().strftime("%H:%M:%S")
        call="00:00:00"
      end
      begin                 
        if @pendingtoken.redirecttime==nil
          @gwaittime=User.time_diff_in_minutes(@pendingtoken.generatedtime,Time.now())
        else
          @gwaittime=User.time_diff_in_minutes(@pendingtoken.generatedtime,Time.now())
        end
      rescue Exception => ex
        
         ex.message
      end
      @update=Transact.update(@pendingtoken.id,{:waittime=>@gwaittime,:call1=>call,:calledtime => calledtime}) 
      page.redirect_to url_for(:controller=>'client', :action=>'shrink1')   
    end
end
rescue Exception => exw
    a=Dir.pwd()
    if File.directory?("home/ErrorLogs")
      f="home/ErrorLogs"
      Dir.chdir(f)
      fp=File.new("Error.log","a")
      fp.write(Time.now.to_s+"-"+exw.message)
      fp.write("\n")
      fp.close()
      Dir.chdir(a)
    else
      e="/home"
      Dir.chdir(e)
      FileUtils.mkdir_p 'ErrorLogs'
      f="home/ErrorLogs"
      Dir.chdir(f)
      fp=File.new("Error.log","a")
      fp.write(Time.now.to_s+"-"+exw.message)
      fp.write("\n")
      fp.close()
      Dir.chdir(a)
    end
     exw.message
  end
end


def onhold
@counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
@transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno])  
if @transact==nil
    render :update do |page|        
        page.redirect_to url_for(:controller=>'client', :action=>'holdtokens')        
    end     
  else
    begin
      session[:gvar]=0
      session[:b]=0
      session[:flag]=false
      @counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
      @transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno]) 
      if @transact==nil
        render :update do |page|        
          page.redirect_to url_for(:controller=>'client', :action=>'holdtokens')        
        end         
      else    
        if @transact.update_attributes(params[:transact])
          @gservicedtime=Time.now()
          if @transact.missingflag==nil
            @gtimetaken=User.time_diff_in_minutes(@transact.calledtime,Time.now())
          else
            @gtimetaken=User.time_diff_in_minutes(@transact.call1,Time.now())
          end
          if (params[:missed]=='on')
            @b=Transact.find(:all,:conditions=>["tokenid=? and serviceid=?",@transact.tokenid,@transact.serviceid])
            if @transact.missingflag==nil 
              @b.each do |b|
                b.tokenstatus=3
                b.missingflag=1
                b.save
              end 
            else
              @b.each do |b|
                b.tokenstatus=3
                b.missingflag=2
                b.save
              end
            end
            @c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
            @c.each do |c|
              c.tokenstatus=0
              c.save
            end    
          else
            @b= Transact.update(@transact.id,{:login=>@@session['user']['login'], :tokenstatus=> '1', :servicedtime=>@gservicedtime,:timetaken => @gtimetaken}) 
            @c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
            @c.each do |c|
              c.tokenstatus=0
              c.save
            end      
            @t= Transact.delete_all(["tokenstatus=4 and tokenid= ? and counterno<>? and serviceid=?",@transact.tokenid,@counter.counterno,@transact.serviceid])
          end
          @counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
          render :update do |page|        
            page.redirect_to url_for(:controller=>'client', :action=>'holdtokens')        
          end  
        else
          render :update do |page|        
            page.redirect_to url_for(:controller=>'client', :action=>'holdtokens')        
          end  
        end
      end
    rescue Exception => exc
      render :update do |page|        
        page.redirect_to url_for(:controller=>'client', :action=>'holdtokens')        
      end  
    end      
  end  
end

def missed
begin
  
  @counter=User.find(:first,:conditions=>["login=?",@session['user']])      
  @x=Tokendisplay.update(@counter.counterno,{:tokenno=>'0000'}) 
  @transact= Transact.find(:first,:conditions=>["counterno = ? AND tokenstatus=2",@counter.counterno])
  if @transact.pullcounter!=nil
    @transact.counterno=@transact.pullcounter
    @transact.save
  end		
  @set=Setting.find(:first)
  if @transact.missingflag==nil 
    @transact.missingflag=0
    @transact.save
  end
  @b=Transact.find(:all,:conditions=>["tokenid=? and serviceid=?",@transact.tokenid,@transact.serviceid])
  @b.each do |b|
    if b.missingflag==nil 
      b.missingflag=0
      b.save
    end  
  end
  if @transact.missingflag<@set.missingcount
    if @transact.redirecttime==nil
      @gwaittime=User.time_diff_in_minutes(@transact.generatedtime,Time.now())
    else
      @gwaittime=User.time_diff_in_minutes(@transact.redirecttime,Time.now())
  end		
      @user_login=@session['user']
      
      @b.each do |b|
          
      b.waittime=@gwaittime
      b.tokenstatus=3
      b.flag='N'
      b.missingflag=b.missingflag+1
      if b.calledtime.strftime("%H:%M:%S") !=Time.parse('00:00:00').strftime("%H:%M:%S")
        b.call1= Time.now().strftime("%H:%M:%S")                          	
      else
        b.calledtime=Time.now().strftime("%H:%M:%S")                               
      end
      if(@set.missingcount==b.missingflag)
        b.missingflag=1000
               end
      b.save
    end #end of loop
  else
    @b.each do |b|
      b.tokenstatus=3
      b.missingflag=100
      b.call1=Time.now()
      b.save
    end
  end  #end of if
  render :update do |page|
    @counter=User.find(:first,:conditions=>["login=?",@session['user']])
    Transact.transaction do
      @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0  and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:lock=>'LOCK IN SHARE MODE')         
      if(@pendingtoken==nil)
        page.redirect_to url_for(:controller=>'client', :action=>'transact')  
      else
        @update=Transact.update(@pendingtoken.id,{:tokenstatus=>2}) 
        @t= Transact.find(:all,:conditions=>["tokenstatus=0 and id<>? and tokenno=?",@update.id,@update.tokenno],:lock=>'LOCK IN SHARE MODE')
        @t.each do |c| 
          c.tokenstatus=4 
          c.save 
        end
        page.redirect_to url_for(:controller=>'client', :action=>'status')   
      end 
    end
  end
rescue Exception => exc    
  STDERR.puts "Error is #{exc.message}"
end               
end

def missed1
begin
@counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']]) 
@transact= Transact.find(:first,:conditions=>["counterno = ? AND tokenstatus=2",@counter.counterno])
if @transact.pullcounter!=nil
  @transact.counterno=@transact.pullcounter
  @transact.save   
end
@set=Setting.find(:first)
if @transact.missingflag==nil 
  @transact.missingflag=0
  @transact.save
end
@b=Transact.find(:all,:conditions=>["tokenid=? and serviceid=?",@transact.tokenid,@transact.serviceid])
  if @transact.missingflag<@set.missingcount
    if @transact.redirecttime==nil
      @gwaittime=User.time_diff_in_minutes(@transact.generatedtime,Time.now())
    else
      @gwaittime=User.time_diff_in_minutes(@transact.redirecttime,Time.now())
    end
    @b.each do |b|
      b.waittime=@gwaittime
      b.login=@@session['user']['login']
      b.tokenstatus=3
      b.missingflag=b.missingflag+1
      if(b.calledtime==nil)
        b.calledtime=Time.now()
      else
        b.call1=Time.now()
      end
      b.save
    end 
  else
    @b.each do |b|
      b.login=@@session['user']['login']
      b.tokenstatus=3
      b.missingflag=100
      b.call1=Time.now()
      b.save
    end
  end
  @c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
  @c.each do |c|
    c.tokenstatus=0
    c.save
  end 
  render :update do |page|
    @counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
    Transact.transaction do
      @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0  and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:lock=>'LOCK IN SHARE MODE')         
      if(@pendingtoken==nil)
        page.redirect_to url_for(:controller=>'client', :action=>'transact')  
      else
        @update=Transact.update(@pendingtoken.id,{:tokenstatus=>2}) 
        @t= Transact.find(:all,:conditions=>["tokenstatus=0 and id<>? and tokenno=?",@update.id,@update.tokenno],:lock=>'LOCK IN SHARE MODE')
        @t.each do |c| 
          c.tokenstatus=4 
          c.save 
        end
        page.redirect_to url_for(:controller=>'client', :action=>'status')   
      end 
    end
  end
rescue Exception => exc
  STDERR.puts "Error is #{exc.message}"
end               
end


def missedstatus111
@counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']]) 
@transact= Transact.find(:first,:conditions=>["counterno = ? AND tokenstatus=2",@counter.counterno])
if @transact.pullcounter!=nil
  @transact.counterno=@transact.pullcounter
  @transact.save
end
@b=Transact.find(:all,:conditions=>["tokenid=? and serviceid=?",@transact.tokenid,@transact.serviceid])
  if @transact.missingflag==nil 
    @b.each do |b|
      b.tokenstatus=3
      b.missingflag=1
      b.calledtime=Time.now()
      b.save
    end 
  else
    @b.each do |b|
      b.tokenstatus=3
      b.missingflag=2
      b.save
    end
  end
  @c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
  @c.each do |c|
    c.tokenstatus=0
    c.save
  end 
render :update do |page|
 page.redirect_to url_for(:controller=>'client', :action=>'shrink1')   
end
end




def missedstatus
@counter=User.find(:first,:conditions=>["login=?",@session['user']]) 
@transact= Transact.find(:first,:conditions=>["counterno = ? AND tokenstatus=2",@counter.counterno])
  if @transact.pullcounter!=nil
    @transact.counterno=@transact.pullcounter
     @transact.save
  end
  @b=Transact.find(:all,:conditions=>["tokenid=? and serviceid=?",@transact.tokenid,@transact.serviceid])
  if @transact.missingflag==nil 
    if @transact.redirecttime==nil
      @gwaittime=User.time_diff_in_minutes(@transact.generatedtime,Time.now())
    else
      @gwaittime=User.time_diff_in_minutes(@transact.redirecttime,Time.now())
    end
    @b.each do |b|
      b.waittime=@gwaittime
      b.tokenstatus=3
      b.missingflag=1
      b.calledtime=Time.now()
      b.save
    end 
  else
    @b.each do |b|
      b.tokenstatus=3
      b.missingflag=2
      b.call1=Time.now()
      b.save
    end
  end
@c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
@c.each do |c|
  c.tokenstatus=0
  c.save
end 
  render :update do |page|
    @counter=User.find(:first,:conditions=>["login=?",@session['user']])
    Transact.transaction do
      @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0  and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:lock=>'LOCK IN SHARE MODE')        
      if(@pendingtoken==nil)
        page.redirect_to url_for(:controller=>'client', :action=>'shrink1')   
      else
        @update=Transact.update(@pendingtoken.id,{:tokenstatus=>2}) 
        @t= Transact.find(:all,:conditions=>["tokenstatus=0 and id<>? and tokenno=?",@update.id,@update.tokenno],:lock=>'LOCK IN SHARE MODE') 
        @t.each do |c| 
          c.tokenstatus=4 
          c.save 
        end
        page.redirect_to url_for(:controller=>'client', :action=>'shrinkstatus')   
      end
    end
  end
end

def hold
@counter=User.find(:first,:conditions=>["login=?",@session['user']])
@transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno])  
@update1=Transact.update(@transact.id,{:tokenstatus=>9}) 
Transact.transaction do           
    @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0 and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:lock=>'LOCK IN SHARE MODE')   
    if(@pendingtoken==nil)
      render :update do |page|
        page.redirect_to url_for(:controller=>'client', :action=>'transact')
      end
    else
      @update=Transact.update(@pendingtoken.id,{:tokenstatus=>2}) 
      @t= Transact.find(:all,:conditions=>["tokenstatus=0 and id<>? and tokenno=?",@update.id,@update.tokenno],:lock=>'LOCK IN SHARE MODE')  	
      @t.each do |c| 
        c.tokenstatus=4 
        c.save 
      end
      render :update do |page|
        page.redirect_to url_for(:controller=>'client', :action=>'status')
      end
    end #if end
  end
end


 
 def holdtokens
 end
 
def showattended
  render :update do |page|        
    page.redirect_to url_for(:controller=>'client', :action=>'attended')        
  end  
end

def counter
render :update do |page|
    page.redirect_to url_for(:controller=>'client', :action=>'counter1')
  end
end  
 

def backtransact
 @counter=User.find(:first,:conditions=>["login=?",@@session['user']['login']])
  @transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno])  
    Transact.transaction do           
      @pendingtoken =Transact.find(:first,:conditions=>["tokenstatus=0 and counterno=?",@counter.counterno],:order=>"redirecttime DESC,ctypeid ASC,tokenid ASC",:lock=>'LOCK IN SHARE MODE')   
        if(@pendingtoken==nil)
          redirect_to :action => "transact"
        else
          @update=Transact.update(@pendingtoken.id,{:tokenstatus=>2}) 
          @t= Transact.find(:all,:conditions=>["tokenstatus=0 and id<>? and tokenno=?",@update.id,@update.tokenno],:lock=>'LOCK IN SHARE MODE')  	
          @t.each do |c| 
              c.tokenstatus=4 
              c.save 
            end
          redirect_to :action => "status"
        end #if end
      end
end

end

