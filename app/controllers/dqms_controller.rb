class DqmsController < ApplicationController
require 'net/http' 
require 'uri'  
require 'rexml/document'
include REXML

begin
      file = File.new("D:/DQM_XML.xml")
      doc = Document.new(file)
      @cmt_server_ip= doc.root.elements[1].elements["CMT_SERVER_IP"].text
      @cmt_port_number=doc.root.elements[1].elements["CMT_PORT"].text
      res = Net::HTTP.start("#{@cmt_server_ip}","#{@cmt_port_number}")
      web_client_api :hello1, :xmlrpc, "http://#{@cmt_server_ip}:#{@cmt_port_number}/hello1/api"    

  def login
      @login=params[:login]
      @password=params[:password]
      @sole_id=Setting.find(:first)
      soleid=@sole_id.soleid
      if @login == [''] or @password == ['']
             flash[:notice]="Username or password should not blank..."
             redirect_to  :controller => 'dqms',:action => "index" 
      else 
           begin              
                @service_output= hello1.login(params[:login],params[:password],soleid)
                @session['user']=params['login']
                 if @service_output=="Admin"
                    @chk_user=User.find(:first,:conditions=>["login=?","#{@login}"])
                    if @chk_user !=nil
                       flash[:notice] = 'User is already logged in...' 
                       redirect_to  :controller => 'dqms',:action => "index" 
                    else
                      @asd=User.new(:login=>"#{@login}",:usertype=>"#{@service_output}")
                      @asd.save
                      redirect_to  :controller => 'users',:action => "admin" 
                    end                      
                 elsif
                    @service_output=="Operator" 
                    @chk_user=User.find(:first,:conditions=>["login=?","#{@login}"])
                    if @chk_user !=nil 
                       flash[:notice] = 'User is already logged in...' 
                       redirect_to  :controller => 'dqms',:action => "index"
                    else
                       @asd=User.new(:login=>"#{@login}",:usertype=>"#{@service_output}")
                       @asd.save
                       redirect_to :controller =>'client',:action => "updateteller"
                    end   
                 elsif 
                    @service_output=="message"
                    flash[:notice] = 'User is already logged in...' 
                    redirect_to  :controller => 'dqms',:action => "index" 
                 elsif 
                    @service_output=="message1" 
                    flash[:notice]="Username or password incorrect..."
                    redirect_to  :controller => 'dqms',:action => "index" 
                 elsif
                    @service_output=="message2" 
                    flash[:notice]="User get blocked contact your admin..."
                    redirect_to  :controller => 'dqms',:action => "index" 
                 elsif
                    @service_output=="message3" 
                    flash[:notice]="User not valid for this DQM..."
                    redirect_to  :controller => 'dqms',:action => "index" 
                 elsif
                    flash[:notice]="Username or password incorrect..."
                    redirect_to  :controller => 'dqms',:action => "index" 
                 end
           rescue Timeout::Error 
                render :file => "#{RAILS_ROOT}/public/500.html", :layout => false, :status => 500
           end
      end
end

def logout
         @user_find=User.find(:first,:select => "login,id,usertype,counterno,loginstatus",:conditions=>["login=?",@session['user']])
         if @user_find==nil
            render :file => "#{RAILS_ROOT}/public/500.html", :layout => false, :status => 500
         else
             if @user_find.usertype=="Admin" and @user_find.counterno==0
                   @user_find.destroy
                   @session['user']=nil
                   if session[:shutdown]=='1'
                      Counter.update_all({:loginstatus=>'N'})
                      @user_all=User.find(:all)
                      @user_all.each do |u|
                          u.destroy
                      end
                      reset_session
                      exec "sudo halt"
                   end
             elsif @user_find.usertype=="Admin" or @user_find.usertype=="Operator" and @user_find.counterno!=0
                   counter_search=Counter.find(:first,:conditions=>["counterno=? and loginstatus='Y'",@user_find.counterno])
                   Counter.update(counter_search.id,{:loginstatus=> 'N'})
                   Tokendisplay.update(@user_find.counterno,{:tokenno=>'0000',:calledtime=>'00:00:00'}) 
                   @pending_token=Transact.count(:all,:conditions=>["tokenstatus in (?) and counterno=?",[2,4],@user_find.counterno])
                   if @pending_token==0
                      @user_find.destroy
                      @session['user']=nil
                      render :update do |page|
                          page.redirect_to  :action=>"signout"
                      end
                    else
                       @transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@user_find.counterno])
                       if @transact !=nil and @transact!=[]
                          @timetaken=User.time_diff_in_minutes(@transact.calledtime,Time.now())
                          Transact.update(@transact.id,{:login=>@user_find.login,:tokenstatus=> '1', :servicedtime=>Time.now(),:timetaken => @timetaken,:stpname=>"#{params[:stp]}",:nonstpname=>"#{params[:nonstp]}",:bulkcount=>"#{params[:bulkcount]}"}) 
                          @token=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
                          @token.each do |token|
                                 token.tokenstatus=0
                                 token.save
                          end  
                       end
                       @user_find.destroy
                       @session['user']=nil
                       render :update do |page|
                          page.redirect_to  :action=>"signout"
                       end
                  end # pending_token if end
              elsif @user_find.usertype=="Operator" and @user_find.counterno==0
                    @user_find.destroy
                    @session['user']=nil 
              end #@user_find if-else end
           end
end

def user_logout
    @id=params[:id]
    @del_users=User.find(:first,:conditions=>["id=?","#{@id}"])
    @counter=Counter.find(:first,:conditions=>["counterno=? and loginstatus='Y'",@del_users.counterno])
    if @counter !=nil
       Counter.update(@counter.id,{:loginstatus=> 'N'})
    end
    @del_users.destroy
    flash[:notice]="User is logged out now,please check."
    redirect_to  :controller => 'dqms',:action => "release" 
end
        
end
rescue
end
