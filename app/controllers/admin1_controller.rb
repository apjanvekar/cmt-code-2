class Admin1Controller < ApplicationController
require 'net/http' 
require 'uri'   
begin
    res = Net::HTTP.start("10.24.94.185", 2374)  
    web_client_api :hello1, :xmlrpc, "http://10.24.94.185:2374/hello1/api"
    def login
          @login=params[:login]
          @password=params[:password]
          if @login == [''] or @password == ['']
             flash[:notice]="Username or password should not blank..."
             redirect_to  :controller => 'admin1',:action => "index" 
          else 
           begin              
             @service_output= hello1.login(params[:login],params[:password])
             @login=params[:login]
             @password=params[:password]
             @salt=Digest::SHA1.hexdigest("change-me--#{@password}--")
             @session['user']=params['login']
             if @service_output=="meassage2"
                flash[:notice]="User is blocked..."
             end
             if @service_output=="meassage1"
                flash[:notice]="Username or Password is incorrect..."
             end 
             if @service_output=="Admin"
                    @chk_user=User.find_by_sql("select * from users where login='#{@login}'")
                    if @chk_user !=nil
                      @chk_user.each do |usr_delete|  
                           usr_delete.destroy
                      end
                      @asd=User.new(:login=>"#{@login}",:password=>"#{@salt}",:usertype=>"#{@service_output}")
                      @asd.save
                      redirect_to  :controller => 'users',:action => "admin" 
                    else
                      @asd=User.new(:login=>"#{@login}",:password=>"#{@salt}",:usertype=>"#{@service_output}")
                      @asd.save
                      redirect_to  :controller => 'users',:action => "admin" 
                    end                      
             elsif
                @service_output=="Operator" 
                @chk_user=User.find_by_sql("select * from users where login='#{@login}'")
                if @chk_user !=nil 
                   @chk_user.each do |usr_delete|  
                        usr_delete.destroy
                   end              
                   @asd=User.new(:login=>"#{@login}",:password=>"#{@salt}",:usertype=>"#{@service_output}")
                   @asd.save
                   redirect_to :controller =>'client',:action => "updateteller"
                else
                   @asd=User.new(:login=>"#{@login}",:password=>"#{@salt}",:usertype=>"#{@service_output}")
                   @asd.save
                   redirect_to :controller =>'client',:action => "updateteller"
                end   
             elsif 
                @service_output== "message"
                @msg="User is already logged in..."
                flash[:notice] = 'User is already logged in...' 
                redirect_to  :controller => 'admin1',:action => "index" 
             elsif 
                @service_output== "message1" 
                flash[:notice]="User ID / Password incorrect"
                redirect_to  :controller => 'admin1',:action => "index" 
             elsif
                @service_output== "message2" 
                flash[:notice]="User get blocked contact your admin.."
                redirect_to  :controller => 'admin1',:action => "index" 
             elsif
                flash[:notice]="Username or Password incorrect..."
                redirect_to  :controller => 'admin1',:action => "index" 
             end
         
         rescue Timeout::Error 
                render :file => "#{RAILS_ROOT}/public/500.html", :layout => false, :status => 500
            end
            end
end

  
def logout
    
         @counter=User.find(:first,:select => "login,id,counterno",:conditions=>["login=?",@session['user']])
         @session['user']
         if @counter!=nil
                login=@counter.login
                @service_output= hello1.logout(login)
                if @service_output=="Admin"
                       @del=User.find(:first,:conditions=>["loginstatus=? AND login=?",'Y',"#{login}"])
                       @status_close=params[:id]
                       if(@status_close!=nil)
                           @cn=@counter.counterno
                           @cls=Transact.update_all({:tokenstatus=>'0'},{:counterno=>"#{@cn}",:tokenstatus=>'2'})
                           puts @cls.inspect
                           
                        end   
                       
                       if @counter.counterno!=0
                            @transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@del.counterno])
                            Tokendisplay.update(@counter.counterno,{:tokenno=>'0000'})   
                            render :update do |page|
                              if @transact==nil 
                                 @counter1=Counter.find(:first,:conditions=>["counterno=? and loginstatus='Y'",@counter.counterno])	
                                 @b= Counter.update(@counter1.id,{:loginstatus=> 'N'})  
                                 @del.destroy
                                 puts "-----------------------------------------------1"
                                 @session['user']=nil
			                     page.redirect_to  :action=>"logout2"
                                 #reset_session
                                 #render :action => "logout" 
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
                                 @del.destroy
                                 puts "-----------------------------------------------2"
                                 #reset_session
                                 @session['user']=nil
                                 page.redirect_to  :action=>"logout2"
                               end
                           end
                       else
                           @del.destroy
                           puts "-----------------------------------------------6"
                                 #reset_session
                                 @session['user'] = nil
                                 render :action => "logout"
                       end
               elsif @service_output=="Operator" 
                     @del=User.find(:first,:conditions=>["loginstatus=? AND login=?",'Y',"#{login}"])
                     @status_close=params[:id]
                       if(@status_close!=nil)
                           @cn=@counter.counterno
                           @cls=Transact.update_all({:tokenstatus=>'0'},{:counterno=>"#{@cn}",:tokenstatus=>'2'})
                           puts "((((((((()))))))))))))))))))))))))))))))"
                           puts @cls.inspect
                           
                        end 
                     if @del.counterno!=0
                        @transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@del.counterno])
                        Tokendisplay.update(@counter.counterno,{:tokenno=>'0000'})   
                        render :update do |page|
                               if @transact==nil 
                                  @counter1=Counter.find(:first,:conditions=>["counterno=? and loginstatus='Y'",@counter.counterno])	
                                  @b= Counter.update(@counter1.id,{:loginstatus=> 'N'})  
                                  @del.destroy
                                  puts "-----------------------------------------------3"
                                  #reset_session
                                  @session['user']=nil
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
                                  @del.destroy
                                  puts "-----------------------------------------------4"
                                  #reset_session
                                  @session['user']=nil
                                  page.redirect_to  :action=>"logout2"
                               end  
                       end
                  else
                      @del.destroy
                      puts "-----------------------------------------------5"
                      #reset_session
                      @session['user']=nil
                      render :action => "logout2"
                   end
               end
         else
            render :file => "#{RAILS_ROOT}/public/500.html", :layout => false, :status => 500 
            #render :file => "#{RAILS_ROOT}/app/views/error/500.rhtml", :layout => false, :status => 500 
            #def render_optional_error_file(status_code)
                #render :template => "error/500", :status => 500, :layout => 'application'
            #end

         end             
      
  end
=begin  
 rescue 
        @updatetellerpage=params[:id]
        if @updatetellerpage=='one'
             puts "are u correct"
             redirect_to :controller => 'admin1',:action => "updatetellererrorpage" 
        elsif @updatetellerpage=='transactid'
          render :update do |page|
              page.redirect_to  :action=>"transacterrorpage"
          end
        else
            redirect_to :controller => 'admin1',:action => "logouterror" 
        end   
   end
=end 
rescue
        puts "are u here"        
end
end
