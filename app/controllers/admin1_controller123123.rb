 class Admin1Controller < ApplicationController

web_client_api :hello1, :xmlrpc, "http://137.141.160.147:2374/hello1/api"
  def login
        puts "****************************fffffffffffff************************"
        @service_output= hello1.login(params[:login],params[:password])
        puts "****************************fffffffffffff************************"
        @login=params[:login]
        
        @password=params[:password]
        @salt=Digest::SHA1.hexdigest("change-me--#{@password}--")
        @session['user']=params['login']
         
      if @service_output=="Admin"
            puts "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT"
                    puts @asd=User.new(:login=>"#{@login}",:password=>"#{@salt}",:usertype=>"#{@service_output}")
                    puts @asd.save
                    redirect_to  :controller => 'users',:action => "admin" 
                    
                    
       elsif @service_output=="superadmin"
           
          redirect_to  :controller => 'users',:action => "Sadmin"
       
      elsif   @service_output=="Operator" 
          @asd=User.new(:login=>"#{@login}",:password=>"#{@salt}",:usertype=>"#{@service_output}")
                    @asd.save
        redirect_to :controller =>'client',:action => "updateteller"
                    #@asd1=User.new(:login=>"#{@login}",:password=>"#{@salt}",:usertype=>"#{@service_output}")
                    #@asd1.save
        
      elsif   @service_output== "message"
           puts "^^^^^^^^^^^^^^^^^^^"
           @msg="User is already logged in......."
           flash[:notice] = 'User is already logged in...' 
           redirect_to  :controller => 'admin1',:action => "index" 
      elsif @service_output== "message1" 
           puts "***************"
           flash[:notice]="User ID / Password Incorrect"
           redirect_to  :controller => 'admin1',:action => "index" 
      elsif @service_output== "message2" 
           puts "***************"
           flash[:notice]="You cannot login !!"
           redirect_to  :controller => 'admin1',:action => "index" 
      end
      
  end
  
  def logout
      puts "u r in logout mode.................>>>>>>>>>"
        @counter=User.find(:first,:select => "login,id,counterno",:conditions=>["login=?",@session['user']])
        puts @session['user']
        puts @counter.inspect
        puts @counter.id
        #loginid=@counter.id
        login=@counter.login
        #puts login=x.login  
      @service_output= hello1.logout(login)
=begin
        if @service_output=="true"
             puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
             puts "admin gets logout................................"
             
            @del=User.find(:first,:conditions=>["loginstatus=? AND login=?",'Y',"#{login}"])
            @counter1=Counter.find(:first,:conditions=>["counterno=? and loginstatus='Y'",@counter.counterno])	
            @b= Counter.update(@counter1.id,{:loginstatus=> 'N'})  
            puts  @del.destroy
             
           
            
           render :action => "logout"
           #redirect_to :controller =>'admin1',:action => "logout"
           puts "just chk itttttttttttttttttt"
          
           
       end
=end 
        if @service_output=="Admin"
            @del=User.find(:first,:conditions=>["loginstatus=? AND login=?",'Y',"#{login}"])
            puts "+++++++++++++++++++++"
            #puts @del.inspect
            #puts  @del.destroy
            #puts "=============================="
            #p render :action => "logout"
            if @del.counterno!=0
                @transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@del.counterno])
                Tokendisplay.update(@counter.counterno,{:tokenno=>'0000'})   
                render :update do |page|
                    if @transact==nil 
                        @counter1=Counter.find(:first,:conditions=>["counterno=? and loginstatus='Y'",@counter.counterno])	
                        @b= Counter.update(@counter1.id,{:loginstatus=> 'N'})  
                        puts  @del.destroy
                        @session['user'] = nil
				reset_session
                        #render :action => "logout"
                        page.redirect_to  :action=>"logout2"
                    else
                         if @transact.update_attributes(params[:transact])
                             @gservicedtime=Time.now()
                             @gtimetaken=User.time_diff_in_minutes(@transact.calledtime,Time.now())
                            @b= Transact.update(@transact.id,{:login=>"#{login}",:tokenstatus=> '1', :servicedtime=>Time.now(),:timetaken => @gtimetaken}) 
                            @c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
                            @c.each do |c|
                                c.tokenstatus=0
                                c.save
                            end     
                            @t= Transact.delete_all(["tokenstatus=4 and tokenid= ? and counterno<>? and serviceid=?",@transact.tokenid,@counter.counterno,@transact.serviceid])
                         end
                        @counter1=Counter.find(:first,:conditions=>["counterno=? and loginstatus='Y'",@counter.counterno])	
                        @b= Counter.update(@counter1.id,{:loginstatus=> 'N'})
                        puts  @del.destroy
                        puts "rendering to logout...............((((((())))))))"
                        @session['user'] = nil
				reset_session
                        puts "checking for logout........................."
                         #redirect_to :controller=>"admin1", :action => "index123"
                         page.redirect_to  :action=>"logout2"
                        #render :partial=>"logout"
                        
                    end
                end
            else
                @del.destroy
                render :action => "logout"
                
            end
        
        elsif @service_output=="Operator" 
            @del=User.find(:first,:conditions=>["loginstatus=? AND login=?",'Y',"#{login}"])
            puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&"
            puts @del.inspect
            puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&"
            if @del.counterno!=0
                @transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@del.counterno])
                Tokendisplay.update(@counter.counterno,{:tokenno=>'0000'})   
                render :update do |page|
                    if @transact==nil 
                        @counter1=Counter.find(:first,:conditions=>["counterno=? and loginstatus='Y'",@counter.counterno])	
                        @b= Counter.update(@counter1.id,{:loginstatus=> 'N'})  
                        puts  @del.destroy
                        @session['user'] = nil
				reset_session
                        #render :action => "logout"
                        page.redirect_to  :action=>"logout2"
                    else
                         if @transact.update_attributes(params[:transact])
                             @gservicedtime=Time.now()
                             @gtimetaken=User.time_diff_in_minutes(@transact.calledtime,Time.now())
                            @b= Transact.update(@transact.id,{:login=>"#{login}",:tokenstatus=> '1', :servicedtime=>Time.now(),:timetaken => @gtimetaken}) 
                            @c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
                            @c.each do |c|
                                c.tokenstatus=0
                                c.save
                            end     
                            @t= Transact.delete_all(["tokenstatus=4 and tokenid= ? and counterno<>? and serviceid=?",@transact.tokenid,@counter.counterno,@transact.serviceid])
                         end
                        @counter1=Counter.find(:first,:conditions=>["counterno=? and loginstatus='Y'",@counter.counterno])	
                        @b= Counter.update(@counter1.id,{:loginstatus=> 'N'})
                        puts  @del.destroy
                        puts "rendering to logout...............((((((())))))))"
                        @session['user'] = nil
				reset_session
                        puts "checking for logout........................."
                         #redirect_to :controller=>"admin1", :action => "index123"
                         page.redirect_to  :action=>"logout2"
                        #render :partial=>"logout"
                        
                    end
                end
            else
                @del.destroy
                render :action => "logout"
                
            end
        end
      
    end

end
