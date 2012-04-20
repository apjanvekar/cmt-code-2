#An unpublished work of Sprylogic Technologies Ltd. 
# © Copyright Sprylogic Technologies Ltd. 2008. All rights reserved 

class UsersController < ApplicationController
  require 'fpdf'
  require "excel"
  require 'active_record'
  require 'optparse'
  require 'rubygems'		
  include Spreadsheet
  layout 'accounts'
  before_filter :login_required
   $count=0
   $tot_diff=0
  def index
    
    list
    render :action => 'list'
  end

def superadmin
end
def cancel
render :update do |page|

page.redirect_to url_for(:controller=>'users', :action=>'list')
end
end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @user_pages, @users = paginate :users, :per_page => 10
  end

  def show
   
     params[:login]
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
  
def signup
    case @request.method
      when :post
        @user = User.new(@params['user'])
        
        if @user.save      
          @session['user'] = User.authenticate(@user.login, @params['user']['password'])
          flash['notice']  = "Signup successful"
          redirect_to :action => "list"          
        end
      when :get
        @user = User.new
    end      
  end  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy1
    
    User.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  def refresh_onlineservice
      render :update do |page|
      page.replace_html('onlineinfo', :partial =>'servicewise')
      end
    end
  
  def refresh_online
      render :update do |page|
      page.replace_html('onlineinfo', :partial =>'onlineinfo')
      end
    end
    
     def refresh_onlinecounterwise
      render :update do |page|
      page.replace_html('onlineinfo', :partial =>'counterwise')
      end
    end
def refresh_floor
      render :update do |page|
      page.replace_html('floor_div', :partial =>'floorview')
      end
    end
def refresh_floor1
  render :update do |page|
      page.replace_html('floor_div', :partial =>'floorview1')
    
      end
    end
def back_floor
 render :update do |page|
  page.redirect_to url_for(:controller=>'users', :action=>'floorviewmain')   
    
      end

end
  def back_counter
 render :update do |page|
  page.redirect_to url_for(:controller=>'users', :action=>'onlineinfomain')   
    
      end

end

 def back_service
 render :update do |page|
  page.redirect_to url_for(:controller=>'users', :action=>'onlineinfomain')   
    
      end

end

 def back_online
 render :update do |page|
  page.redirect_to url_for(:controller=>'users', :action=>'onlineinfomain')   
    
      end

end
  #function currently not used
  def updatetoken
   # p $counterno
   #find tokenid to be currently  served
   @counter=User.find(:first,:conditions=>["login=?",@session['user']['login']])
    @transact= Tokenpending.find(:first,:conditions=>["tokenstatus=0 and counterno=?",@counter.counterno])
    p "tokenno is #{@transact.tokenid}"
    
    #find records whose tokenid is same as serving on current counter
    @t= Tokenpending.find(:all,:conditions=>["tokenstatus=0 and counterno<>?",@counter.counterno])
    
     @t[0].counterno
    #updating tokenstatus to be 1 for same token pending at others counters
    @t.each do |c|
    c.tokenstatus=1
    c.save
    
  end
  end
  
  
  def display
  end
  
#function for calculating waittime
def time_diff_in_minutes (time1,time2)

  
end

def welcome
end  



#CODE FOR CHECKING PENDING TOKENS AND UPDATING MISSING TOKEN AFTER SPECIFIC TIME INTERVAL AND TIME COUNT
 def pending
 @session['user']
@counter=User.find(:first,:conditions=>["login=?",@session['user']])

@a=@counter.counterno
pendingtoken =Transact.count(["tokenstatus=0 and counterno=?","#{@a}]"])
pendingtoken.inspect

render :text=>"Pending Token: #{pendingtoken}"
 @set=Setting.find(:first)
@missing=Transact.find(:all,:conditions=>["tokenstatus=3 and missingflag<?  and calledtime is not null",@set.missingcount])
 @missing.each do |m| 
  if(m.call1==nil)
  @gtimetaken=User.time_diff_in_minutes(m.calledtime,Time.now())
  else
  @gtimetaken=User.time_diff_in_minutes(m.call1,Time.now())
  end
 
 #**************CODE FOR REMOVING COLONS IN TIMEFORMAT************
 @h=@gtimetaken.to_s[0,2]
 @m=@gtimetaken.to_s[3,2]
 @s=@gtimetaken.to_s[6,2]
 puts "value=#{@h}#{@m}#{@s}"
 @time="#{@h}#{@m}#{@s}"
 #@m=@gtimetaken.to_s[,2]
 #*******************END*****************************************************
 
 
 #***********************CODE FOR FETCHING MISSINGTIME AND THEN COMPARING ****************
@set=Setting.find(:first)
 #puts "gold=#{@set.missingtime.strftime("%H:%M:%S")}"
hour1="select sum(TIME_TO_SEC(missingtime)) as 'ss' from settings"
diff1=Transact.find_by_sql(hour1)
difference=diff1[0].ss
#p "missing time111111=#{difference}"
seconds   =  difference.to_i % 60
difference = (difference.to_i - seconds.to_i) / 60
minutes    =  difference.to_i % 60
difference = (difference.to_i - minutes.to_i) / 60
hours      =  difference.to_i % 24

#puts "#{hours}:#{minutes}:#{seconds}"
if(hours<10)
hours="0#{hours}"
end

if(minutes<10)
minutes="0#{minutes}"
end

if(seconds<10)
seconds="0#{seconds}"
end
#puts "#{hours}:#{minutes}:#{seconds}"
timetaken="#{hours}#{minutes}#{seconds}"

#************************************END****************************  



  if @time.to_i>=timetaken.to_i 
 
  @c=Transact.find(:all,:conditions=>["serviceid=? and tokenstatus=3 and missingflag<?",m.serviceid,@set.missingcount])
    
    @c.each do |d|
    @p=Transact.find(:first,:conditions=>["tokenno=? and tokenstatus=2",m.tokenno])  
    if @p!=nil
    d.tokenstatus=4
      d.missingflag=0
    d.save
    else
    d.tokenstatus=0
    d.save
    end
  
    end
  end
end
z=UsersController.new
z.insertstatus

  end
 

def insertstatus
  @new=Status.find(:first)
  if @new==nil
  @new=Status.new
  @setting=Setting.find(:first)
  #puts @setting.branchname
  
  
  @new.branchname=@setting.branchname
  
  @tokenserved=Transact.count(["tokenstatus = 1"])
  @new.totaltokenserved=@tokenserved
  @tokenpending=Transact.count(["tokenstatus = 0"])
  @new.pendingtokencount=@tokenpending
  @activecounters=Counter.count(["loginstatus = 'Y'"])
  @new.noofactivecounters=@activecounters
  @goldpending=Transact.count(["ctypeid=1 and tokenstatus = 0"])
  @new.goldcount=@goldpending
  @customerpending=Transact.count(["ctypeid=2 and tokenstatus = 0"])
  @new.customercount=@customerpending
  @noncustomerpending=Transact.count(["ctypeid=3 and tokenstatus = 0"])
  @new.noncustomercount=@noncustomerpending
  
  
  
  @new.save
  else
     @setting=Setting.find(:first)
  #puts @setting.branchname
  
  
  @new.branchname=@setting.branchname
  
  @tokenserved=Transact.count(["tokenstatus = 1"])
  @new.totaltokenserved=@tokenserved
  @tokenpending=Transact.count(["tokenstatus = 0"])
  @new.pendingtokencount=@tokenpending
  @activecounters=Counter.count(["loginstatus = 'Y'"])
  @new.noofactivecounters=@activecounters
  @goldpending=Transact.count(["ctypeid=1 and tokenstatus = 0"])
  @new.goldcount=@goldpending
  @customerpending=Transact.count(["ctypeid=2 and tokenstatus = 0"])
  @new.customercount=@customerpending
  @noncustomerpending=Transact.count(["ctypeid=3 and tokenstatus = 0"])
  @new.noncustomercount=@noncustomerpending
  
  
  
  @new.save
  end
  
end
    
def pause
      session[:gvar]=0
      session[:b]=0
      @session['user']
      @counter=User.find(:first,:conditions=>["login=?",@session['user']])
      @transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno])    
      Tokendisplay.update(@counter.counterno,{:tokenno=>'0000'})  
      puts "#{params[:transact][:stpname]}"
      render :update do |page|
             if @transact==nil 
                render :action => 'transact'   
             else
                 if params[:transact][:stpname]==""
                       page.alert 'Please select STP name.'
                       #elsif params[:transact][:nonstpname]!="" and params[:transact][:accno]==""   
                       #page.alert 'Please enter account number'      
                 elsif params[:transact][:bulkcount]=="" and params[:transact][:nonstpname]!=""
                       page.alert 'Please enter bulk count.'
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
                              @b= Transact.update(@transact.id,{:tokenstatus=> '1',:pauseflag=>1,:pausetime=>Time.now, :servicedtime=>@gservicedtime,:timetaken => @gtimetaken}) 
                              @c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
                              @c.each do |c|
                                 c.tokenstatus=0
                                 c.save
                              end
                              @t= Transact.delete_all(["tokenstatus=4 and tokenid= ? and counterno<>?",@transact.tokenid,@counter.counterno])          
                          end
                       end    
                       pause=Pausedetail.new
                       pause.counterno=@counter.counterno
	                   pause.login=@session['user']
                       pause.pdate=Time.now.to_date
                       pause.stime=Time.now
                       #pause.reason='Lunch'
                       #pause.reason=['transact']['reasons']
                       pause.pflag=1
	                   pause.save 
                       # enable the button
                       #page<<"Validate();"
                       #page.alert "Taking pause will end the current service request"
                       #page[:time_div].toggle
                       #page[:aux_div].toggle
                       #page << "document.getElementById('dialog_div').style.visibility = 'hidden'"
                        page << "document.getElementById('time').style.visibility = 'hidden'"
                        page << "document.getElementById('logout').style.visibility = 'hidden'"
                        page << "document.getElementById('shrink').style.visibility = 'hidden'"
                        page << "document.getElementById('password').style.visibility = 'hidden'"
                        page << "document.getElementById('counter_div').style.visibility = 'hidden'"
                        page << "document.getElementById('aux_div').style.visibility = 'visible'"
                        page << "document.getElementById('servicetime').style.visibility = 'hidden'"
                        #page << "document.getElementById('pausetime').style.visibility = 'visible'"
                        #page[:time_div].visual_effect :pulsate
                        page << "document.getElementById('redirect').disabled = true;"
                        page << "document.getElementById('counter').disabled = true;"
                        page << "document.getElementById('missing').disabled = true;"
                        page << "document.getElementById('submit').disabled = true;"
                        #page << "document.getElementById('Release').disabled = false;"
                        page << "document.getElementById('pause').disabled = true;"  
                        page << "document.getElementById('go').disabled = false;"  
                  end
             end
      end
  end 

def shrinkpause  
  
    session[:gvar]=0
    session[:b]=0
   @counter=User.find(:first,:conditions=>["login=?",@session['user']])
  @transact= Transact.find(:first,:conditions=>["tokenstatus=2 and counterno=?",@counter.counterno])    
      Tokendisplay.update(@counter.counterno,{:tokenno=>'0000'})     
   render :update do |page|
    if @transact==nil 
      render :action => 'shrink1'   
    else    
      if params[:transact][:stpname]==""
           page.alert 'Please select STP name.'
           #elsif params[:transact][:nonstpname]!="" and params[:transact][:accno]=="" 
            #if params[:transact][:accno]==""
            #page.alert 'Please enter account number'
          else
      if @transact.update_attributes(params[:shrink1])
        @gservicedtime=Time.now()        
          @gtimetaken=User.time_diff_in_minutes(@transact.calledtime,Time.now())
         #checking whether the missed is clicked or not if yes then update tokenstatus=3 else tokenstatus=1
                  if (params[:missed]=='on')

            @t= Transact.find(:all,:conditions=>["tokenid= ?",@transact.tokenid])
             
            #updating tokenstatus to be 1 for same token pending at others counters
            @t.each do |c| 
            c.tokenstatus=3
            c.calledtime=@transact.calledtime
            c.save
          end 
          else
        @user_name=@session['user']
        @b= Transact.update(@transact.id,{:login=>"#{@user_name}",:tokenstatus=> '1',:pauseflag=>1,:pausetime=>Time.now, :servicedtime=>@gservicedtime,:timetaken => @gtimetaken}) 
        @c=Transact.find(:all,:conditions=>["tokenid=? and tokenstatus=4 and serviceid<>?",@transact.tokenid,@transact.serviceid])
        @c.each do |c|
        c.tokenstatus=0
        c.save
        end
           @t= Transact.delete_all(["tokenstatus=4 and tokenid= ? and counterno<>?",@transact.tokenid,@counter.counterno])
      end
  end
  @user_name=@session['user']
  pause=Pausedetail.new
  pause.counterno=@counter.counterno
	pause.login=@user_name
  pause.pdate=Time.now.to_date
  pause.stime=Time.now
   pause.pflag=1
	pause.save 
   
 
     page << "document.getElementById('time').style.visibility = 'hidden'"
      page << "document.getElementById('shrinkfull').style.visibility = 'hidden'"
      page << "document.getElementById('aux_div').style.visibility = 'visible'"
      page << "document.getElementById('servicetime').style.visibility = 'hidden'"
      #page << "document.getElementById('pausetime').style.visibility = 'visible'"
      #page[:time_div].visual_effect :pulsate
      page << "document.getElementById('submit').disabled = true;"
      #page << "document.getElementById('Release').disabled =false;"
      page << "document.getElementById('pause').disabled = true;"  
      page << "document.getElementById('go').disabled = false;"        
    end
    end
   end
  end 



 #code to release the pause button and reset the form
def release
    @userlogin=@session['user']
 @counter=User.find(:first,:conditions=>["login=?",@session['user']])
   @a=Pausedetail.find(:first,:conditions=>["pflag=1 and counterno=?",@counter.counterno])
   Pausedetail.update(@a.id,{:pflag=>0,:etime=>Time.now})
   
   
   @b=Transact.find(:first,:conditions=>["pauseflag=1 and counterno=?",@counter.counterno])
   if @b==nil
     
    else
      
   Transact.update(@b.id,{:pauseflag=>0,:releasetime=>Time.now,:login=>"#{@userlogin}"})
 end
  
    render :update do |page|
       page.replace_html 'aux_div', 'Please wait releasing pause ....'
    page.redirect_to url_for(:controller=>'client', :action=>'updatetransact')
    #page.form.reset :form1
    end
end
# end release

def shrinkrelease
    @userlogin=@session['user']
 @counter=User.find(:first,:conditions=>["login=?",@session['user']])
   @a=Pausedetail.find(:first,:conditions=>["pflag=1 and counterno=?",@counter.counterno])
   Pausedetail.update(@a.id,{:pflag=>0,:etime=>Time.now,:login=>"#{@userlogin}"})
   
   
   @b=Transact.find(:first,:conditions=>["pauseflag=1 and counterno=?",@counter.counterno])
   if @b==nil
     
    else
      
   Transact.update(@b.id,{:pauseflag=>0,:releasetime=>Time.now})

 end
  
  
    render :update do |page|
       page.replace_html 'aux_div', 'Please wait releasing pause ....'
       page << "document.getElementById('Release').disabled = false;"
    page.redirect_to url_for(:controller=>'client', :action=>'updateshrink')
    #page.form.reset :form1
    end
end




def password 
   @user = @session['user']
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
                            end   
                        end
                    end   
                end
            end
        end
    end
end  



#########################################################        
#                      Report                           # 
#########################################################

def masterreport
spreadsheet_file="spreadsheet_report.xls"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
@count=0
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>10)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()

workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)

#worksheet.format_column(0,35,data_format)
worksheet.write(1, 0, ['Token No','Date','GeneratedTime','Service Name', 'Login', 'CalledTime','CalledTime2','WaitTime','ServicedTime','TimeTaken','TokenStatus'], header_format)


worksheet.write(0, 3, 'Master Report For Today\'s Date', page_header_format)
current_row=1
current_row=current_row+1


#Transact.find(:only => [:tokenno, :login,:calledtime]).each do |player|
#Transact.find(:all,:conditions=>'tokenstatus=0 or tokenstatus=1 or tokenstatus=3').each do |player|


Transact.find(:all,:select=>'distinct serviceid,tokenno,transdate,generatedtime,login,calledtime,call1,waittime,servicedtime,timetaken,tokenstatus',:conditions=>'tokenstatus=0 or tokenstatus=1 or tokenstatus=3').each do |player|
#worksheet.format_row(current_row, current_row==2 ? 20 :30, player_name_format)
worksheet.write(current_row, 0, player.tokenno)

@date= player.transdate.strftime("%d/%m/%Y")
worksheet.write(current_row, 1, @date)

 @gentime= player.generatedtime.strftime("%H:%M:%S")
worksheet.write(current_row, 2, @gentime)

@service= player.serviceid
@a=Service.find(:first,:conditions=>["serviceid=?",@service])

worksheet.write(current_row, 3, @a.servicename)

worksheet.write(current_row, 4, player.login)

if(player.calledtime!=nil)
 @time= player.calledtime.strftime("%H:%M:%S")
worksheet.write(current_row, 5, @time)
end
if(player.call1!=nil)
@time1= player.call1.strftime("%H:%M:%S")
worksheet.write(current_row, 6, @time1)
end

if(player.waittime!=nil)
@waittime= player.waittime.strftime("%H:%M:%S")
worksheet.write(current_row, 7, @waittime)
end
if(player.servicedtime!=nil)
@sertime= player.servicedtime.strftime("%H:%M:%S")
worksheet.write(current_row, 8, @sertime)
end

if(player.timetaken!=nil)
@timetaken= player.timetaken.strftime("%H:%M:%S")
worksheet.write(current_row, 9, @timetaken)
end

@status= player.tokenstatus


if(@status=="0")
worksheet.write(current_row, 10, "InQueue")
elsif(@status=="1")
worksheet.write(current_row, 10, "Complete")
@count=@count+1
elsif(@status=="3")
worksheet.write(current_row, 10, "Missed")
end



current_row=current_row+1


#worksheet.write(current_row, 0, ['Game', 'Wins', 'Losses'], header_format)
#current_row=current_row+1


end


hour1="select avg(TIME_TO_SEC(timetaken)) as 'ss' from transacts where tokenstatus=1"
diff1=Transact.find_by_sql(hour1)
difference=diff1[0].ss
 "avg time=#{difference}"


seconds   =  difference.to_i % 60
difference = (difference.to_i - seconds.to_i) / 60
minutes    =  difference.to_i % 60
difference = (difference.to_i - minutes.to_i) / 60
hours      =  difference.to_i % 24


 
if(hours<10)
hours="0#{hours}"
end

if(minutes<10)
minutes="0#{minutes}"
end

if(seconds<10)
seconds="0#{seconds}"
end

timetaken="#{hours}:#{minutes}:#{seconds}"
  


h="select LPAD(avg(HOUR(timetaken)*3600),2,'0') as 'hh'  from transacts where tokenstatus=1"
hour=Transact.find_by_sql(h)

m="select LPAD(avg(MINUTE(timetaken)*60),2,'0') as 'mm' from transacts where tokenstatus=1"
min=Transact.find_by_sql(m) 

s="select LPAD(avg(TIME_TO_SEC(timetaken)),2,'0') as 'ss' from transacts where tokenstatus=1"
sec=Transact.find_by_sql(s)
a="#{hour[0].hh}"
b="#{min[0].mm}"
c="#{sec[0].ss}"



if a=="0."
a="00"
end

if b=="0."
b="00"
end

if c=="0."
c="00"
end
 "count= #{@count}"
if(@count>0)
a=a.to_i/@count
b=b.to_i/@count
c=c.to_i/@count
end
current_row=current_row+1
format1=Format.new(:color=>'red', :bold=>true)
workbook.add_format(format1)
worksheet.write(current_row, 8,"Average Mean Time",format1)
worksheet.write(current_row, 9,timetaken)
workbook.close

#@filename = "/home/Spry/DQMS/public/spreadsheet_report.xls"
#@filename="C:/ROR/InstantRails/rails_apps/DQMS_ROR_ver1.0.1/spreadsheet_report.xls"
pw=Dir.pwd()
        Dir.chdir(pw)
        filename=pw.to_s+"/"+spreadsheet_file
	   
    send_file(filename,
      :disposition => 'attachment',
      :encoding => 'utf8',
      :type => 'application/octet-stream')
  end
  
def ServicewiseTokens1
require 'prawn'

@t1=Transact.find_by_sql("select min(transdate)as m,max(transdate)as n from transacts")
 @t1
@t1.each do |x|
   @a=x.m
    @b= x.n
   
 end
 
 Prawn::Document.generate("ServicewiseTokenBreakup.pdf") do |pdf|
 #Prawn::Document.generate("ServicewiseTokenBreakup.pdf") do
  pdf.font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"
 
  "Servicewise Breakup Of Tokens From #{@a} To #{@b}"
   

  #text "this is a test " * 100
  
  #@t1.each do |tb|
  #p text "Book: #{tb.serviceid}", :size => 16, :style => :bold, :spacing => 4
  #pdf.text "Author: #{book.author}", :spacing => 16
  #pdf.text book.description
  #pdf.start_new_page
#end

   pdf.text("Servicewise Breakup Of Tokens From #{@a} To #{@b}")
   @t1.each do |x1|
     
    info=[["Transdate","#{x1.m}"]]
   pdf.table info,
  :border_style => :grid,
  :font_size => 11,
  :position => :center,
  :column_widths => { 0 => 150, 1 => 250},
  :align => { 0 => :right, 1 => :left, 2 => :right, 3 => :left},
  :row_colors => ["d2e3ed", "FFFFFF"]
pdf.font_size 14
end

  #text1 'Counter','Counter Status','Token No.','Service Name', 'Customer Type', 'Threshold Time','Waittime','timetaken'
end



#worksheet.write(0 , 3, "Servicewise Breakup Of Tokens From '#{@a}' To  #{@b}",page_header_format)
#pdf = Prawn::Document.new 

filename="ServicewiseTokenBreakup.pdf"
pw=Dir.pwd()
        Dir.chdir(pw)
        
       # pdf.render_file('ServicewiseTokenBreakup.pdf') 
	   
    send_file(filename,
      :disposition => 'attachment',
      :encoding => 'utf8',
      :type => 'application/octet-stream')
end


def ServiceTkensh

end

def servicewisemonthh

end

def avgwaittservicetmonthh

end

def daywiseserviceofferedh
  
  end
  
def masterreporth
end


#########################################################        
#              Servicewise Breakup Of Tokens From       # 
#########################################################
  

def ServicewiseTokens
spreadsheet_file="ServicewiseTokens.xls"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
@count=0
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>30)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>10)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>12)

workbook.add_format(page_header_format)
workbook.add_format(player_name_format)

workbook.add_format(header_format)
workbook.add_format(data_format)

#worksheet.format_column(0,35,data_format)
@t1=Transact.find_by_sql("select min(transdate) as m,max(transdate) as n from transacts;")
 @t1
@t1.each do |x|
  @a=x.m
   @b= x.n
  
  end
worksheet.write(0 , 3, "Servicewise Breakup Of Tokens For Today's Date",page_header_format)
#worksheet.write(0, 3, "Servicewise Breakup Of Tokens '#{@time.strftime("%Y-%m-%d")}'",header_format)
current_row=3
current_row=current_row+1
worksheet.write(3, 0, ['Counter','Counter Status','Token No.','Service Name', 'Customer Type', 'Threshold Time','WaitTime','TimeTaken'], header_format)



#Transact.find(:only => [:tokenno, :login,:calledtime]).each do |player|
#Transact.find(:all,:conditions=>'tokenstatus=0 or tokenstatus=1 or tokenstatus=3').each do |player|
#Transact.find(:all,:select=>'counterno,tokenno,ctypeid,serviceid,waittime,timetaken',:conditions=>'tokenstatus=0 or tokenstatus=1 or tokenstatus=3').each do |player|
#worksheet.format_row(current_row, current_row==2 ? 20 :30, player_name_format)



@t = Counter.find_by_sql("select * from counters where counterstatus=1 order by counterno" ) 
  @t.each do |c|
    worksheet.write(current_row, 0, c.counterno)
    if (c.loginstatus=='Y')
      @pause=Transact.find_first(["counterno=? and pauseflag=1",c.counterno])
      if @pause!=nil 
        if @pause.pauseflag==1    
          worksheet.write(current_row, 1, @pause.reasons) 
				else 
          worksheet.write(current_row, 1, "Logged In") 
        end
      else 
				worksheet.write(current_row, 1, "Logged In")
      end 
    else
      worksheet.write(current_row, 1, "Logged Out")
    end 
    if (c.loginstatus=='Y')
      @a= Transact.find_first(["counterno = ? and tokenstatus=2",c.counterno])
      if (@a==nil) 
      else
        worksheet.write(current_row, 2, @a.tokenno)  
        @b= Service.find_first(["serviceid = ? ",@a.serviceid])
        worksheet.write(current_row, 3, @b.servicename)
        @c= Customertype.find_first(["ctypeid = ? ",@a.ctypeid]) 
        worksheet.write(current_row, 4, @c.ctypedesc )
        @d= Service.find_first(["serviceid = ? ",@a.serviceid]) 
        @d.thresholdtime.strftime("%H:%M:%S") 
        worksheet.write(current_row, 5, @d.thresholdtime.strftime("%H:%M:%S"))  
        worksheet.write(current_row, 6, @a.waittime.strftime("%H:%M:%S"))   
      end
    end 
    current_row=current_row+1
end
current_row=current_row+1
#format1=Format.new(:color=>'red', :bold=>true)
#workbook.add_format(format1)
#worksheet.write(current_row, 8,"Average Mean Time",format1)
#worksheet.write(current_row, 9,timetaken)
workbook.close

#@filename = "/home/Spry/DQMS/public/spreadsheet_report.xls"
#@filename="C:/ROR/InstantRails/rails_apps/DQMS_ROR_ver1.0.1/spreadsheet_report.xls"
pw=Dir.pwd()
        Dir.chdir(pw)
        filename=pw.to_s+"/"+spreadsheet_file
	   
    send_file(filename,
      :disposition => 'attachment',
      :encoding => 'utf8',
      :type => 'application/octet-stream')
end




#########################################################        
#  Report No::  Benchmark Service Time of all Services  # 
#########################################################

def Servicebenchmark
spreadsheet_file="BenchmarkTime.xls"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
@count=0
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>20)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()

workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)
worksheet.write(3, 0, ['Service ID','Service Name','Benchmark Time','Service Status'], header_format)
worksheet.write(0, 3, 'Benchmark Service Time of all Services', page_header_format)
current_row=3
current_row=current_row+1
@t = Service.find_by_sql("select * from services" ) 
  @t.each do |c|
    worksheet.write(current_row, 0, c.serviceid)
    worksheet.write(current_row, 1, c.servicename)     
    worksheet.write(current_row, 2, c.thresholdtime.strftime("%H:%M:%S"))  
    if (c.servicestatus=="1")
      worksheet.write(current_row, 3, "Active")
    else
      worksheet.write(current_row, 3, "Inactive")
    end
    current_row=current_row+1
  end
    current_row=current_row+1
#format1=Format.new(:color=>'red', :bold=>true)
#workbook.add_format(format1)
#worksheet.write(current_row, 8,"Average Mean Time",format1)
#worksheet.write(current_row, 9,timetaken)
workbook.close

#@filename = "/home/Spry/DQMS/public/spreadsheet_report.xls"
#@filename="C:/ROR/InstantRails/rails_apps/DQMS_ROR_ver1.0.1/spreadsheet_report.xls"
pw=Dir.pwd()
        Dir.chdir(pw)
        filename=pw.to_s+"/"+spreadsheet_file
	   
    send_file(filename,
      :disposition => 'attachment',
      :encoding => 'utf8',
      :type => 'application/octet-stream')
  end
  
  
#########################################################        
#  Report No::  Daywise Services                        # 
#########################################################
    
def Daywiseservice
spreadsheet_file="Daywiseservice.xls"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>20)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()

workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)
worksheet.write(1, 0, ['Date','Service ID','Service Name'], header_format)
worksheet.write(3, 3, 'Daywise Services ', page_header_format)
current_row=1
current_row=current_row+1
@t = Transact.find_by_sql("select distinct(serviceid),transdate from Transacts" ) 
  @t.each do |c|
    worksheet.write(current_row, 0, c.transdate.strftime('%m/%d/%Y'))
    worksheet.write(current_row, 1, c.serviceid)  
    @b= Service.find_first(["serviceid = ? ",c.serviceid])    
    worksheet.write(current_row, 2, @b.servicename)  
    current_row=current_row+1
  end
    current_row=current_row+1
#format1=Format.new(:color=>'red', :bold=>true)
#workbook.add_format(format1)
#worksheet.write(current_row, 8,"Average Mean Time",format1)
#worksheet.write(current_row, 9,timetaken)
workbook.close

#@filename = "/home/Spry/DQMS/public/spreadsheet_report.xls"
#@filename="C:/ROR/InstantRails/rails_apps/DQMS_ROR_ver1.0.1/spreadsheet_report.xls"


pw=Dir.pwd()
        Dir.chdir(pw)
        filename=pw.to_s+"/"+spreadsheet_file
	   
    send_file(filename,
      :disposition => 'attachment',
      :encoding => 'utf8',
      :type => 'application/octet-stream')
end

#########################################################        
#  Report No::  Average ServiceTime and Waittime From   # 
#########################################################

def avgwaittservicet
spreadsheet_file="avgwaittservicet.xls"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>10)

#player_name_format=Format.new(:color=>'red', :bold=>true,:size=>10)
#player_name_format=Format.new(:color=>'red', :bold=>true,:size=>10)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()

workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)
worksheet.write(3, 0, ['Token No.','Date','ServicedTime','WaitTime'], header_format)
@t1=Transact.find_by_sql("select min(transdate) as m,max(transdate) as n from transacts;")
 @t1
@t1.each do |x|
    @a=x.m
     @b= x.n

  end
#worksheet.write(0, 0, "Servicewise Breakup Of Tokens From '#{@a}' To  #{@b}",page_header_format)
worksheet.write(0, 3, "Average ServiceTime and WaitTime For Today's Date", page_header_format)
current_row=3
current_row=current_row+1
@t = Transact.find_by_sql("select * from transacts where tokenstatus = 1" ) 
  @t.each do |c|
     c.tokenno
     c.waittime
      c.timetaken
      c.transdate
    worksheet.write(current_row, 0, c.tokenno)
    worksheet.write(current_row, 1, c.transdate.strftime("%Y-%m-%d"))    
    worksheet.write(current_row, 3, c.waittime.strftime("%H:%M:%S"))
    worksheet.write(current_row, 2, c.timetaken.strftime("%H:%M:%S"))

    #worksheet.write(current_row, 1, c.waittime.strftime("%H:%M:%S"))
    #worksheet.write(current_row, 2, c.timetaken.strftime("%H:%M:%S"))
    
    
    current_row=current_row+1
  end
    current_row=current_row+1
 @time = Transact.find_by_sql("select SEC_TO_TIME(AVG(TIME_TO_SEC(timetaken))) as AverageServicedTime,SEC_TO_TIME(AVG(TIME_TO_SEC(waittime))) as AverageWaitTime from transacts;" ) 
   @time.each do |d|
format1=Format.new(:color=>'red', :bold=>true)
workbook.add_format(format1)
worksheet.write(current_row, 2,"Average Waittime: #{d.AverageWaitTime}")
worksheet.write(current_row, 1,"Average Service Time: #{d.AverageServicedTime}")
end
workbook.close


#@filename = "/home/Spry/DQMS/public/spreadsheet_report.xls"
#@filename="C:/ROR/InstantRails/rails_apps/DQMS_ROR_ver1.0.1/spreadsheet_report.xls"


pw=Dir.pwd()
        Dir.chdir(pw)
        filename=pw.to_s+"/"+spreadsheet_file
	   
    send_file(filename,
      :disposition => 'attachment',
      :encoding => 'utf8',
      :type => 'application/octet-stream')
    end
    def selection1
      
    end
    def selection2
         
   end
   
   
#########################################################        
#  Report No::  Average ServiceTime And Waittime        # 
#########################################################

def avgwaittservicetmonth
  
spreadsheet_file="avgwaittservicetmonth.xls"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>10)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()

workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)
worksheet.write(3, 0, ['Token No','Date','Servicetime','Waittime'], header_format)



worksheet.write(0, 3, "Average ServiceTime And WaitTime From #{params[:startdate]} To #{params[:enddate]}", page_header_format)
current_row=3
current_row=current_row+1

@t = Transact.find_by_sql("select * from transactmaster
        where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and tokenstatus=1 " ) 
        
        p @t
  @t.each do |c|
     c.tokenno
    
    
    worksheet.write(current_row, 0, c.tokenno)
    worksheet.write(current_row, 3, c.waittime.strftime("%H:%M:%S"))
    worksheet.write(current_row, 2, c.timetaken.strftime("%H:%M:%S"))
    worksheet.write(current_row, 1, c.transdate.strftime("%Y-%m-%d"))
    current_row=current_row+1
  end
    current_row=current_row+1



@time1 = Transact.find_by_sql("select SEC_TO_TIME(AVG(TIME_TO_SEC(timetaken))) as AverageServicedTime,SEC_TO_TIME(AVG(TIME_TO_SEC(waittime))) as AverageWaitTime 
                                        from transactmaster
                                        where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and tokenstatus=1 " ) 


@time1.each do |d|
format1=Format.new(:color=>'red', :bold=>true)
workbook.add_format(format1)
worksheet.write(current_row, 3,"Average Waittime: #{d.AverageWaitTime}")
worksheet.write(current_row, 2,"Average Servicedtime: #{d.AverageServicedTime}")
end
workbook.close

#@filename = "/home/Spry/DQMS/public/spreadsheet_report.xls"
#@filename="C:/ROR/InstantRails/rails_apps/DQMS_ROR_ver1.0.1/spreadsheet_report.xls"


pw=Dir.pwd()
        Dir.chdir(pw)
        filename=pw.to_s+"/"+spreadsheet_file
	   
    send_file(filename,
      :disposition => 'attachment',
      :encoding => 'utf8',
      :type => 'application/octet-stream')
end


#########################################################        
#  Report No::Servicewise Breakup Of Tokens             # 
#########################################################

def servicewisemonth
  
    params[:startdate]
             params[:enddate]
            
	if params[:enddate].to_date >=params[:startdate].to_date  
  
spreadsheet_file="servicewisemonth.xls"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>10)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()

workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)
worksheet.write(3, 0, ['Service Name ','No. Of Tokens'], header_format)



worksheet.write(0, 3, "Servicewise Breakup Of Tokens From #{params[:startdate]} To #{params[:enddate]} ", page_header_format)
current_row=3
current_row=current_row+1





@t = Transact.find_by_sql("select count(tokenno) as Total_Tokens,serviceid 
                              from transactmaster 
                              where transdate<='#{params[:enddate]}'and transdate>='#{params[:startdate]}' 
                              group by serviceid" ) 

  @t.each do |c|
    worksheet.write(current_row, 1, c.Total_Tokens)
    @b= Service.find_first(["serviceid = ? ",c.serviceid])      
    worksheet.write(current_row, 0, @b.servicename)  
    current_row=current_row+1
  end
    current_row=current_row+1
    
#format1=Format.new(:color=>'red', :bold=>true)
#workbook.add_format(format1)
#worksheet.write(current_row, 8,"Average Mean Time",format1)
#worksheet.write(current_row, 9,timetaken)


workbook.close

#@filename = "/home/Spry/DQMS/public/spreadsheet_report.xls"
#@filename="C:/ROR/InstantRails/rails_apps/DQMS_ROR_ver1.0.1/spreadsheet_report.xls"


pw=Dir.pwd()
Dir.chdir(pw)
filename=pw.to_s+"/"+spreadsheet_file	   
send_file(filename,
  :disposition => 'attachment',
  :encoding => 'utf8',
  :type => 'application/octet-stream')
  
  
  else
				
			flash[:notice]="Please select proper dates"
		end
  
  
  
end

def daywiseserviceoffered
spreadsheet_file="daywiseserviceoffered.xls"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>10)
header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()
workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)
worksheet.write(3, 0, ['Date ','ServiceName','No. Of Tokens Served'], header_format)





worksheet.write(0, 3, "Daywise Service Offered From #{params[:startdate]} To #{params[:enddate]}", page_header_format)
current_row=3
current_row=current_row+1



#########################################################        
# Report for the Daywise Services Offered for month      # 
#########################################################

        @t=Transact.find_by_sql("select distinct(serviceid) as Service_ID,transdate as Date, count(tokenno) as
                                    tokenno        
                                 from transactmaster 
                                 where transdate<='#{params[:enddate]}'and transdate>='#{params[:startdate]}' 
                                 and tokenstatus=1
                                 group by serviceid
                                 order by transdate ")
        
        
  @t.each do |c|
    worksheet.write(current_row, 2, c.tokenno)
    @b= Service.find_first(["serviceid = ? ",c.Service_ID])      
    worksheet.write(current_row, 1, @b.servicename)  
   # worksheet.write(current_row, 2, c.Service_ID)
worksheet.write(current_row, 0, c.Date)    
    current_row=current_row+1
  end
    current_row=current_row+1
#format1=Format.new(:color=>'red', :bold=>true)
#workbook.add_format(format1)
#worksheet.write(current_row, 8,"Average Mean Time",format1)
#worksheet.write(current_row, 9,timetaken)
workbook.close

#@filename = "/home/Spry/DQMS/public/spreadsheet_report.xls"
#@filename="C:/ROR/InstantRails/rails_apps/DQMS_ROR_ver1.0.1/spreadsheet_report.xls"
pw=Dir.pwd()
Dir.chdir(pw)
filename=pw.to_s+"/"+spreadsheet_file
send_file(filename,
:disposition => 'attachment',
:encoding => 'utf8',
:type => 'application/octet-stream')
end
  
def selection
  
end

#########################################################        
# Report No::for the Daywise Services Offered for month # 
#########################################################

def employeescore
  

 @user=params[:user]
#params[:employeescore][:login] 

 @user1 = params[:user]


#p params[:employeescore][:login] 



spreadsheet_file="employeescore.xls"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>10)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()

workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)
worksheet.write(3, 0, ['Service Name','Threshold Time','Trans Date','Time Taken','Score'], header_format)
=begin
p"-----------"
@Curdate=Date.today
p "#{@Curdate.strftime('%B')}"
p "#{@Curdate.strftime('%Y')}"
p"-----------"
=end

worksheet.write(0, 3, "#{@user}'s Score From  #{params[:startdate]} TO #{params[:enddate]}", page_header_format)
current_row=3
current_row=current_row+1
#puts @user

@transact=Transact.find_by_sql("select  * from transactmaster 
                                      where login='#{@user}' and  transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'")
   

p @transact
@transact.each do |c|
  
   p c.id 
  #c.timetaken.strftime("%H:%M:%S")
  #worksheet.write(current_row, 0, c.login)
  worksheet.write(current_row, 4, c.score)
  worksheet.write(current_row, 3, c.timetaken.strftime("%H:%M:%S"))  
  worksheet.write(current_row, 2, c.transdate.strftime("%Y-%m-%d"))
  @service=Service.find(:all, :conditions => ["serviceid=?", c.serviceid])
  @service.each do |d|
  worksheet.write(current_row, 0, d.servicename)
  worksheet.write(current_row, 1, d.thresholdtime.strftime("%H:%M:%S"))      
  end
 current_row=current_row+1
 end
 
  
  #
    
=begin
  if (d.thresholdtime.strftime("%H:%M:%S")=='00:25:00')
    if (c.timetaken.strftime("%H:%M:%S")<= '00:02:00')
      worksheet.write(current_row, 4, "10")  
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:02:00') && (c.timetaken.strftime("%H:%M:%S")<='00:04:00'))
      worksheet.write(current_row, 4, "8")  
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:04:00') && (c.timetaken.strftime("%H:%M:%S")<='00:06:00'))
      worksheet.write(current_row, 4, "8")  
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:06:00') && (c.timetaken.strftime("%H:%M:%S")<='00:09:00'))
      worksheet.write(current_row, 4, "6")   
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:09:00') && (c.timetaken.strftime("%H:%M:%S")<='00:12:00'))
      worksheet.write(current_row, 4, "5") 
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:12:00') && (c.timetaken.strftime("%H:%M:%S")<='00:15:00'))
      worksheet.write(current_row, 4, "4")  
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:15:00') && (c.timetaken.strftime("%H:%M:%S")<='00:18:00'))
      worksheet.write(current_row, 4, "3")    
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:18:00') && (c.timetaken.strftime("%H:%M:%S")<='00:21:00'))
      worksheet.write(current_row, 4, "2")   
    else
      worksheet.write(current_row, 4, "0")   
    end
  end
  
  if (d.thresholdtime.strftime("%H:%M:%S")=='00:20:00')
    if (c.timetaken.strftime("%H:%M:%S")<= '00:02:00')
      worksheet.write(current_row, 4, "10")  
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:02:00') && (c.timetaken.strftime("%H:%M:%S")<='00:04:00'))
      worksheet.write(current_row, 4, "8")  
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:04:00') && (c.timetaken.strftime("%H:%M:%S")<='00:06:00'))
      worksheet.write(current_row, 4, "7")  
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:06:00') && (c.timetaken.strftime("%H:%M:%S")<='00:09:00'))
      worksheet.write(current_row, 4, "6")   
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:09:00') && (c.timetaken.strftime("%H:%M:%S")<='00:12:00'))
      worksheet.write(current_row, 4, "4") 
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:12:00') && (c.timetaken.strftime("%H:%M:%S")<='00:15:00'))
      worksheet.write(current_row, 4, "3")  
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:16:00') && (c.timetaken.strftime("%H:%M:%S")<='00:18:00'))
      worksheet.write(current_row, 4, "1")    
    else 
      worksheet.write(current_row, 4, "0")       
    end
  end
  
  if (d.thresholdtime.strftime("%H:%M:%S")=='00:15:00')
    if (c.timetaken.strftime("%H:%M:%S")<= '00:02:00')
      worksheet.write(current_row, 4, "10")  
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:02:00') && (c.timetaken.strftime("%H:%M:%S")<='00:04:00'))
      worksheet.write(current_row, 4, "7")  
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:04:00') && (c.timetaken.strftime("%H:%M:%S")<='00:06:00'))
      worksheet.write(current_row, 4, "6")  
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:06:00') && (c.timetaken.strftime("%H:%M:%S")<='00:09:00'))
      worksheet.write(current_row, 4, "4")   
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:09:00') && (c.timetaken.strftime("%H:%M:%S")<='00:12:00'))
      worksheet.write(current_row, 4, "2") 
    else
      worksheet.write(current_row, 4, "0")  
    end
  end
  
  if (d.thresholdtime.strftime("%H:%M:%S")=='00:10:00')
    if (c.timetaken.strftime("%H:%M:%S")<= '00:02:00')
      worksheet.write(current_row, 4, "10")  
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:02:00') && (c.timetaken.strftime("%H:%M:%S")<='00:04:00'))
      worksheet.write(current_row, 4, "6")  
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:04:00') && (c.timetaken.strftime("%H:%M:%S")<='00:06:00'))
      worksheet.write(current_row, 4, "4")  
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:06:00') && (c.timetaken.strftime("%H:%M:%S")<='00:09:00'))
      worksheet.write(current_row, 4, "1")   
    else
      worksheet.write(current_row, 4, "0") 
    end
  end
  
  if (d.thresholdtime.strftime("%H:%M:%S")=='00:08:00')
    if (c.timetaken.strftime("%H:%M:%S")<= '00:02:00')
      worksheet.write(current_row, 4, "10")  
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:02:00') && (c.timetaken.strftime("%H:%M:%S")<='00:04:00'))
      worksheet.write(current_row, 4, "5")  
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:04:00') && (c.t imetaken.strftime("%H:%M:%S")<='00:06:00'))
      worksheet.write(current_row, 4, "3")  
    else
      worksheet.write(current_row, 4, "0")   
    end  
  end
  
  if (d.thresholdtime.strftime("%H:%M:%S")=='00:05:00')
    if (c.timetaken.strftime("%H:%M:%S")<= '00:02:00')
      worksheet.write(current_row, 4, "10")  
    elsif ((c.timetaken.strftime("%H:%M:%S")>'00:02:00') && (c.timetaken.strftime("%H:%M:%S")<='00:04:00'))
      worksheet.write(current_row, 4, "2")  
    else
      worksheet.write(current_row, 4, "0")    
    end    
=end    
#end  
  
    current_row=current_row+1
  #end
   # current_row=current_row+1
#format1=Format.new(:color=>'red', :bold=>true)
#workbook.add_format(format1)
#worksheet.write(current_row, 8,"Average Mean Time",format1)
#worksheet.write(current_row, 9,timetaken)
workbook.close

#@filename = "/home/Spry/DQMS/public/spreadsheet_report.xls"
#@filename="C:/ROR/InstantRails/rails_apps/DQMS_ROR_ver1.0.1/spreadsheet_report.xls"
pw=Dir.pwd()
Dir.chdir(pw)
filename=pw.to_s+"/"+spreadsheet_file
send_file(filename,
:disposition => 'attachment',
:encoding => 'utf8',
:type => 'application/octet-stream')
end
      # **********************************>>> PNB NEW REQUIREMENT <<<*************************************
      # ********************************** Newly Created Report add on 02-12-2010 ************************
      # >>--------------------------------> Report1 <-------------------------------------------<<
def Counter
 
 p  params[:startdate]
 spreadsheet_file="Counter.xls"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
@count=0
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>20)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()
workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)

worksheet.write(0, 3, 'Counter wise Report', page_header_format)
current_row=3
 header_row=2
 footer_row=0
current_row=current_row+1
 
 if params[:startdate].to_date == Date.today  

 @t = Service.find_by_sql("select distinct(counterno) as a1
						from transacts
						where transdate='#{params[:startdate]}' order by counterno")  
		 @t.each do|a| 
			@counterno = a.a1 
			
			@data=Service.find_by_sql("select tokenno,transdate,generatedtime,calledtime,servicedtime,login,serviceid,waittime,timetaken,tokenstatus
										from transacts
										where transdate='#{params[:startdate]}' and counterno='#{@counterno}' ") 
             @count = 0
            
             header_row=footer_row+2
              p "********** #{header_row}"
              worksheet.write(header_row, 0, ['Counter No'],header_format)
              worksheet.write(header_row,1,@counterno,header_format)
                header_row=header_row+2
                p "&&&&&&& #{header_row}"
              worksheet.write(header_row, 0, ['Sr.No','Tokenno','Transdate','Generatedtime','Calledtime','Servicedtime','Login','Serviceid','Waittime','Timetaken','Tokenstatus'
], header_format)
              current_row=header_row+2
              p "********** #{current_row}"
			 @data.each do |c| 


    worksheet.write(current_row, 0, @count=@count+1)
    worksheet.write(current_row, 1, c.tokenno)     
    worksheet.write(current_row, 2, c.transdate)  
    worksheet.write(current_row, 3, c.generatedtime) 
    worksheet.write(current_row, 4, c.calledtime) 
    worksheet.write(current_row, 5, c.servicedtime) 
    worksheet.write(current_row, 6, c.login) 
     Service.find(:all, :conditions => ["serviceid=?", c.serviceid]).each do |d| 

    worksheet.write(current_row, 7, d.servicename) 
    worksheet.write(current_row, 8, c.waittime) 
    worksheet.write(current_row, 9, c.timetaken) 
    if (c.tokenstatus=="1")
      worksheet.write(current_row, 10, "Served")
    else
      worksheet.write(current_row, 10, "In Queue")
    end
    current_row=current_row+1
    p current_row
end
   footer_row=current_row
   
   p "@@@@@ #{footer_row}"
 @abc=Service.find_by_sql("select count(tokenno) as tokenno
										from transacts
										where transdate='#{params[:startdate]}' and counterno='#{@counterno}' and tokenstatus=1") 
	worksheet.write(footer_row, 2, ['Token Served'],header_format)
    worksheet.write(footer_row,3,@abc[0].tokenno,header_format)
    
    @abc=Service.find_by_sql("select avg(time_to_sec(timetaken)) as timetaken
														from transacts
														where transdate='#{params[:startdate]}' and counterno='#{@counterno}'and tokenstatus=1") 

								seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24 
								
								 if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
                                @avg="#{hours}:#{minutes}:#{seconds}"
    worksheet.write(footer_row, 6, ['Avg Mean Time to Serve'],header_format)
    worksheet.write(footer_row,7,@avg,header_format)
								   

    footer_row=footer_row+1    
										
  end  
end
else
     @t = Service.find_by_sql("select distinct(counterno) as a1
						from transactmaster
						where transdate='#{params[:startdate]}' order by counterno")  
		 @t.each do|a| 
			@counterno = a.a1 
			
			@data=Service.find_by_sql("select tokenno,transdate,generatedtime,calledtime,servicedtime,login,serviceid,waittime,timetaken,tokenstatus
										from transactmaster
										where transdate='#{params[:startdate]}' and counterno='#{@counterno}' ") 
             @count = 0
            
             header_row=footer_row+2
              p "********** #{header_row}"
              worksheet.write(header_row, 0, ['Counter No'],header_format)
              worksheet.write(header_row,1,@counterno,header_format)
                header_row=header_row+2
                p "&&&&&&& #{header_row}"
              worksheet.write(header_row, 0, ['Sr.No','Tokenno','Transdate','Generatedtime','Calledtime','Servicedtime','Login','Serviceid','Waittime','Timetaken','Tokenstatus'
], header_format)
              current_row=header_row+2
              p "********** #{current_row}"
			 @data.each do |c| 


    worksheet.write(current_row, 0, @count=@count+1)
    worksheet.write(current_row, 1, c.tokenno)     
    worksheet.write(current_row, 2, c.transdate)  
    worksheet.write(current_row, 3, c.generatedtime) 
    worksheet.write(current_row, 4, c.calledtime) 
    worksheet.write(current_row, 5, c.servicedtime) 
    worksheet.write(current_row, 6, c.login) 
     Service.find(:all, :conditions => ["serviceid=?", c.serviceid]).each do |d| 

    worksheet.write(current_row, 7, d.servicename) 
    worksheet.write(current_row, 8, c.waittime) 
    worksheet.write(current_row, 9, c.timetaken) 
    if (c.tokenstatus=="1")
      worksheet.write(current_row, 10, "Served")
    else
      worksheet.write(current_row, 10, "In Queue")
    end
    current_row=current_row+1
    p current_row
end
   footer_row=current_row
   
   p "@@@@@ #{footer_row}"
 @abc=Service.find_by_sql("select count(tokenno) as tokenno
										from transactmaster
										where transdate='#{params[:startdate]}' and counterno='#{@counterno}' and tokenstatus=1") 
	worksheet.write(footer_row, 2, ['Token Served'],header_format)
    worksheet.write(footer_row,3,@abc[0].tokenno,header_format)
    
    @abc=Service.find_by_sql("select avg(time_to_sec(timetaken)) as timetaken
														from transactmaster
														where transdate='#{params[:startdate]}' and counterno='#{@counterno}' and tokenstatus=1") 

								seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24 
								
								 if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
                                @avg="#{hours}:#{minutes}:#{seconds}"
    worksheet.write(footer_row, 6, ['Avg Mean Time to Serve'],header_format)
    worksheet.write(footer_row,7,@avg,header_format)
								   

    footer_row=footer_row+1    
										
  end  
end

end    

workbook.close

pw=Dir.pwd()
        Dir.chdir(pw)
        filename=pw.to_s+"/"+spreadsheet_file
	   
    send_file(filename,
      :disposition => 'attachment',
      :encoding => 'utf8',
      :type => 'application/octet-stream')
  end
 # >>--------------------------------> Report2 <-------------------------------------------<< 
def Countersummery
 p  params[:startdate]
  p  params[:enddate]
 spreadsheet_file="Countersummery.xls"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
@count=0
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>20)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()
workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)

worksheet.write(0, 1, 'Counter Wise Summery Report', page_header_format)
current_row=3
 header_row=2
 footer_row=0
current_row=current_row+1
 
 if params[:startdate].to_date == Date.today  

    @t = Service.find_by_sql("select distinct(counterno) as a1
						from transacts
						where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' order by counterno")  
				 @t.each do|a| 
						 @counterno = a.a1 
			
					@data=Service.find_by_sql("select ctypeid,count(tokenno)as ctokenno,avg(time_to_sec(timetaken)) as timetaken ,avg(time_to_sec(waittime))as timetaken1

											   from transacts
											   where counterno='#{@counterno}'
		                                         and  transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'	
		                                   group by ctypeid ") 
            
              
            if @data != [] 
 
             @count = 0
            
             header_row=footer_row+2
              p "********** #{header_row}"
              worksheet.write(header_row, 0, ['Counter No'],header_format)
              worksheet.write(header_row,1,@counterno,header_format)
                header_row=header_row+2
                p "&&&&&&& #{header_row}"
              worksheet.write(header_row, 0, ['CustomerType','Token Served','Not Served','Avg Time To Served','Avg Time To Wait'], header_format)
              current_row=header_row+2
              p "********** #{current_row}"
			  @data.each do |ctype|


    Customertype.find(:all, :conditions => ["ctypeid=?", ctype.ctypeid]).each do |d| 
       worksheet.write(current_row, 0, d.ctypedesc)
    end
	@data1=Service.find_by_sql("select count(tokenno)as ctokenno

											   from transacts
											   where counterno='#{@counterno}' and ctypeid='#{ctype.ctypeid}' and tokenstatus=1
		                                         and  transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'	
		                                       ") 
		                                      @data1.each do |d| 

    worksheet.write(current_row, 1, d.ctokenno )
    end
    @data1=Service.find_by_sql("select count(tokenno)as ctokenno
 								     from transacts
									 where counterno='#{@counterno}'and tokenstatus=0 and ctypeid='#{ctype.ctypeid}'
		                             and  transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'	
		                             ") 
		                                     @data1.each do |d| 
    
         worksheet.write(current_row, 2, d.ctokenno)
     end  
 	@data1=Service.find_by_sql("select count(tokenno)as ctokenno,avg(time_to_sec(timetaken)) as timetaken ,avg(time_to_sec(waittime))as timetaken1
											   from transacts
											   where counterno='#{@counterno}' and ctypeid='#{ctype.ctypeid}' and tokenstatus=1
		                                         and  transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'	
		                                       ") 
		                         @data1.each do | ctype| 

      seconds   =  ctype.timetaken.to_i % 60
								ctype.timetaken = (ctype.timetaken.to_i - seconds.to_i) / 60
								minutes    = ctype.timetaken.to_i % 60
								ctype.timetaken = (ctype.timetaken.to_i - minutes.to_i) / 60
								hours      =  ctype.timetaken.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								@timetaken="#{hours}:#{minutes}:#{seconds}" 
    worksheet.write(current_row, 3, @timetaken) 
    seconds   =  ctype.timetaken1.to_i % 60
								ctype.timetaken1 = (ctype.timetaken1.to_i - seconds.to_i) / 60
								minutes    =  ctype.timetaken1.to_i % 60
								ctype.timetaken1 = (ctype.timetaken1.to_i - minutes.to_i) / 60
								hours      =  ctype.timetaken1.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								@waittime="#{hours}:#{minutes}:#{seconds}"  
    worksheet.write(current_row, 4, @waittime)
   end    
    current_row=current_row+1
    p current_row
end
   footer_row=current_row
   
   p "@@@@@ #{footer_row}"
   @abc=Service.find_by_sql("select count(tokenno) as tokenno
										from transacts
										where counterno='#{@counterno}'and tokenstatus=1 
		                                         and  transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'") 
										
										
	worksheet.write(footer_row, 0, ['Token Served'],header_format)
    worksheet.write(footer_row,1,@abc[0].tokenno,header_format)
    
    @abc=Service.find_by_sql("select avg(time_to_sec(timetaken)) as timetaken
														from transacts
														 where counterno='#{@counterno}'and tokenstatus=1 
		                                            and  transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'") 

								 seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end
								
								@avgt= "#{hours}:#{minutes}:#{seconds}" 
    worksheet.write(footer_row, 2, ['Avg Mean Time to Serve'],header_format)
    worksheet.write(footer_row,3,@avgt,header_format)
    
     @abc=Service.find_by_sql("select avg(time_to_sec(waittime)) as timetaken
														from transacts
														 where counterno='#{@counterno}'and tokenstatus=1 
		                                            and  transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'") 

								seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end
								
								@avgw= "#{hours}:#{minutes}:#{seconds}" 
                              

	worksheet.write(footer_row, 4, ['Avg Wait Time '],header_format)
    worksheet.write(footer_row,5,@avgt,header_format)							   

    footer_row=footer_row+1    
										
  end  
end
else
   @t = Service.find_by_sql("select distinct(counterno) as a1
						from transactmaster
						where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' order by counterno")  
				 @t.each do|a| 
						 @counterno = a.a1 
			
					@data=Service.find_by_sql("select ctypeid,count(tokenno)as ctokenno,avg(time_to_sec(timetaken)) as timetaken ,avg(time_to_sec(waittime))as timetaken1

											   from transactmaster
											   where counterno='#{@counterno}'
		                                         and  transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'	
		                                   group by ctypeid ") 
            
              
            if @data != [] 
 
             @count = 0
            
             header_row=footer_row+2
              p "********** #{header_row}"
              worksheet.write(header_row, 0, ['Counter No'],header_format)
              worksheet.write(header_row,1,@counterno,header_format)
                header_row=header_row+2
                p "&&&&&&& #{header_row}"
              worksheet.write(header_row, 0, ['CustomerType','Token Served','Not Served','Avg Time To Served','Avg Time To Wait'], header_format)
              current_row=header_row+2
              p "********** #{current_row}"
			  @data.each do |ctype|


    Customertype.find(:all, :conditions => ["ctypeid=?", ctype.ctypeid]).each do |d| 
       worksheet.write(current_row, 0, d.ctypedesc)
   end
    	@data1=Service.find_by_sql("select count(tokenno)as ctokenno

											   from transactmaster
											   where counterno='#{@counterno}' and ctypeid='#{ctype.ctypeid}' and tokenstatus=1
		                                         and  transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'	
		                                       ") 
		                                     @data1.each do |d|


			
    worksheet.write(current_row, 1, d.ctokenno)
    end
    @data1=Service.find_by_sql("select count(tokenno)as ctokenno
 								     from transactmaster
									 where counterno='#{@counterno}'and tokenstatus=0 and ctypeid='#{ctype.ctypeid}'
		                             and  transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'	
		                             ") 
		                                     @data1.each do |d| 
    
         worksheet.write(current_row, 2, d.ctokenno)
     end  
    	@data1=Service.find_by_sql("select count(tokenno)as ctokenno,avg(time_to_sec(timetaken)) as timetaken ,avg(time_to_sec(waittime))as timetaken1
											   from transactmaster
											   where counterno='#{@counterno}' and ctypeid='#{ctype.ctypeid}' and tokenstatus=1
		                                         and  transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'	
		                                       ") 
		                                 @data1.each do | ctype|

      seconds   =  ctype.timetaken.to_i % 60
								ctype.timetaken = (ctype.timetaken.to_i - seconds.to_i) / 60
								minutes    = ctype.timetaken.to_i % 60
								ctype.timetaken = (ctype.timetaken.to_i - minutes.to_i) / 60
								hours      =  ctype.timetaken.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								@timetaken="#{hours}:#{minutes}:#{seconds}" 
    worksheet.write(current_row, 3, @timetaken) 
    seconds   =  ctype.timetaken1.to_i % 60
								ctype.timetaken1 = (ctype.timetaken1.to_i - seconds.to_i) / 60
								minutes    =  ctype.timetaken1.to_i % 60
								ctype.timetaken1 = (ctype.timetaken1.to_i - minutes.to_i) / 60
								hours      =  ctype.timetaken1.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								@waittime="#{hours}:#{minutes}:#{seconds}"  
    worksheet.write(current_row, 4, @waittime) 
    end
    current_row=current_row+1
    p current_row
end
   footer_row=current_row
   
   p "@@@@@ #{footer_row}"
   @abc=Service.find_by_sql("select count(tokenno) as tokenno
										from transactmaster
										where counterno='#{@counterno}'and tokenstatus=1 
		                                         and  transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'") 
										
										
	worksheet.write(footer_row, 0, ['Token Served'],header_format)
    worksheet.write(footer_row,1,@abc[0].tokenno,header_format)
    
    @abc=Service.find_by_sql("select avg(time_to_sec(timetaken)) as timetaken
														from transactmaster
														 where counterno='#{@counterno}'and tokenstatus=1 
		                                            and  transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'") 

								 seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end
								
								@avgt= "#{hours}:#{minutes}:#{seconds}" 
    worksheet.write(footer_row, 2, ['Avg Mean Time to Serve'],header_format)
    worksheet.write(footer_row,3,@avgt,header_format)
    
     @abc=Service.find_by_sql("select avg(time_to_sec(waittime)) as timetaken
														from transactmaster
														 where counterno='#{@counterno}'and tokenstatus=1 
		                                            and  transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'") 

								seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end
								
								@avgw= "#{hours}:#{minutes}:#{seconds}" 

	worksheet.write(footer_row, 4, ['Avg Wait Time'],header_format)
    worksheet.write(footer_row,5,@avgw,header_format)							   

    footer_row=footer_row+1    
										
  end  
end  
 
end    
workbook.close
pw=Dir.pwd()
        Dir.chdir(pw)
        filename=pw.to_s+"/"+spreadsheet_file
	   
    send_file(filename,
      :disposition => 'attachment',
      :encoding => 'utf8',
      :type => 'application/octet-stream')
  end
  
  # >>--------------------------------> Report3 <-------------------------------------------<< 
def Daywisebreakupofservices
 p  params[:startdate]
  
spreadsheet_file="Daywisebreakupofservices.xls"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
@count=0
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>20)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()
workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)

worksheet.write(0, 3, 'Day wise breakup of services ', page_header_format)
 current_row=3
 header_row=2
 footer_row=0
current_row=current_row+1
 
 if params[:startdate].to_date == Date.today  
         
   			 @t = Service.find_by_sql("select distinct(serviceid) as a1
						from transacts
						where transdate>='#{params[:startdate]}' order by counterno")  
				 @t.each do|a| 
						 @serviceid = a.a1 
			
					@data=Service.find_by_sql("select tokenno,ctypeid,generatedtime,calledtime,servicedtime,login,counterno,waittime,timetaken,tokenstatus 
											   from transacts
											   where  serviceid='#{@serviceid}'
		                                         and  transdate='#{params[:startdate]}' ")
	           

            if @data != [] 
 
           
                  Service.find(:all, :conditions => ["serviceid=?",@serviceid ]).each do |d| 
				    @servicename=d.servicename
				  end 
             header_row=footer_row+2
              p "********** #{header_row}"
              worksheet.write(header_row, 0, ['service Name:'],header_format)
              worksheet.write(header_row,1,@servicename,header_format)
                header_row=header_row+2
                p "&&&&&&& #{header_row}"
              worksheet.write(header_row, 0, ['Sr.No','Token No','Customer Type','Calledtime','Generated Time','Serviced Time','Teller Name','Counter','Wait Time','Timetaken','Tokenstatus'], header_format)
              current_row=header_row+2
              p "********** #{current_row}"
			  @data.each do |c|


    worksheet.write(current_row, 0, @count=@count+1)
    worksheet.write(current_row, 1, c.tokenno) 
    Customertype.find(:all, :conditions => ["ctypeid=?", c.ctypeid]).each do |d|     
     worksheet.write(current_row, 2, d.ctypedesc)  
    end 
    worksheet.write(current_row, 3, c.generatedtime) 
    worksheet.write(current_row, 4, c.calledtime) 
    worksheet.write(current_row, 5, c.servicedtime) 
    worksheet.write(current_row, 6, c.login) 
    worksheet.write(current_row, 7,  c.counterno)
    worksheet.write(current_row, 8,  c.waittime)
    worksheet.write(current_row, 9,  c.timetaken)
     if c.tokenstatus.to_i == 1 
        worksheet.write(current_row, 10, "Served")
     else
        worksheet.write(current_row, 10,  "IN Q")
     end
           

    current_row=current_row+1
    p current_row
end
   footer_row=current_row
   
   p "@@@@@ #{footer_row}"
   @abc=Service.find_by_sql("select count(tokenno) as tokenno
										from transacts
										where serviceid='#{@serviceid}' and tokenstatus=1 
		                                         and  transdate='#{params[:startdate]}'") 
								
										
	worksheet.write(footer_row, 3, ['Token Served'],header_format)
    worksheet.write(footer_row,4,@abc[0].tokenno,header_format)
    
    @abc=Service.find_by_sql("select avg(time_to_sec(timetaken)) as timetaken
														from transacts
														where serviceid='#{@serviceid}' and tokenstatus=1 
		                                         and  transdate='#{params[:startdate]}'") 

								 seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24
								
								 if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								
								@avgt= "#{hours}:#{minutes}:#{seconds}" 
    worksheet.write(footer_row, 6, ['Avg Mean Time to Serve'],header_format)
    worksheet.write(footer_row,7,@avgt,header_format)
    
    
    footer_row=footer_row+1    
										
  end  
end
else
    @t = Service.find_by_sql("select distinct(serviceid) as a1
						from transactmaster
						where transdate>='#{params[:startdate]}' order by counterno")  
				 @t.each do|a| 
						 @serviceid = a.a1 
			
					@data=Service.find_by_sql("select tokenno,ctypeid,generatedtime,calledtime,servicedtime,login,counterno,waittime,timetaken,tokenstatus 
											   from transactmaster
											   where  serviceid='#{@serviceid}' 
		                                         and  transdate='#{params[:startdate]}' ")
	           

            if @data != [] 
 
             
                  Service.find(:all, :conditions => ["serviceid=?",@serviceid ]).each do |d| 
				    @servicename=d.servicename
				  end 
             header_row=footer_row+2
              p "********** #{header_row}"
              worksheet.write(header_row, 0, ['service Name:'],header_format)
              worksheet.write(header_row,1,@servicename,header_format)
                header_row=header_row+2
                p "&&&&&&& #{header_row}"
              worksheet.write(header_row, 0, ['Sr.No','Token No','Customer Type','Calledtime','Generated Time','Serviced Time','Teller Name','Counter','Wait Time','Timetaken','Tokenstatus'], header_format)
              current_row=header_row+2
              p "********** #{current_row}"
			  @data.each do |c|


    worksheet.write(current_row, 0, @count=@count+1)
    worksheet.write(current_row, 1, c.tokenno) 
    Customertype.find(:all, :conditions => ["ctypeid=?", c.ctypeid]).each do |d|     
     worksheet.write(current_row, 2, d.ctypedesc)  
    end 
    worksheet.write(current_row, 3, c.generatedtime) 
    worksheet.write(current_row, 4, c.calledtime) 
    worksheet.write(current_row, 5, c.servicedtime) 
    worksheet.write(current_row, 6, c.login) 
    worksheet.write(current_row, 7,  c.counterno)
    worksheet.write(current_row, 8,  c.waittime)
    worksheet.write(current_row, 9,  c.timetaken)
     if c.tokenstatus.to_i == 1 
        worksheet.write(current_row, 10, "Served")
     else
        worksheet.write(current_row, 10,  "IN Q")
     end
           

    current_row=current_row+1
    p current_row
end
   footer_row=current_row
   
   p "@@@@@ #{footer_row}"
   @abc=Service.find_by_sql("select count(tokenno) as tokenno
										from transactmaster
										where serviceid='#{@serviceid}' and tokenstatus=1 
		                                         and  transdate='#{params[:startdate]}'") 
								
										
	worksheet.write(footer_row, 3, ['Token Served'],header_format)
    worksheet.write(footer_row,4,@abc[0].tokenno,header_format)
    
    @abc=Service.find_by_sql("select avg(time_to_sec(timetaken)) as timetaken
														from transactmaster
														where serviceid='#{@serviceid}' and tokenstatus=1 
		                                         and  transdate='#{params[:startdate]}'") 

								 seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24
								
								 if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								
								@avgt= "#{hours}:#{minutes}:#{seconds}" 
    worksheet.write(footer_row, 6, ['Avg Mean Time to Serve'],header_format)
    worksheet.write(footer_row,7,@avgt,header_format)
    
    
    footer_row=footer_row+1    
										
  end  
end
end    
workbook.close
pw=Dir.pwd()
        Dir.chdir(pw)
        filename=pw.to_s+"/"+spreadsheet_file
	   
    send_file(filename,
      :disposition => 'attachment',
      :encoding => 'utf8',
      :type => 'application/octet-stream')
  end
 
   # >>--------------------------------> Report4 <-------------------------------------------<< 
 def Masterreporth 
 
 spreadsheet_file="Masterreport.csv"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
@count=0
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>20)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()
workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)

worksheet.write(0, 3, 'Detailed Master Report', page_header_format)
current_row=3
 header_row=2
 footer_row=0
current_row=current_row+1
 
  @count=0 
  @master=Transact.find_by_sql("select distinct serviceid,tokenno,transdate,generatedtime,login,calledtime,counterno,waittime,servicedtime,timetaken,tokenstatus
						from transactmaster
						where transdate BETWEEN DATE_SUB( CURDATE( ) ,INTERVAL 15 DAY ) AND CURDATE( )
    						and (tokenstatus=0 or tokenstatus=1 or tokenstatus=3 )") 
   
              header_row=footer_row+2
              header_row=header_row+2
              worksheet.write(header_row, 0, ['Sr.No','Token No','Date','Teller Name','Service Name','Generated Time','Called Time','Counter','Wait Time','Serviced Time','Timetaken','Tokenstatus'], header_format)
              current_row=header_row+2
            		 
   @master.each do |player|

    worksheet.write(current_row, 0, @count=@count+1)
    worksheet.write(current_row, 1, player.tokenno)     
    worksheet.write(current_row, 2, player.transdate.strftime("%d/%m/%Y"))  
    worksheet.write(current_row, 3, player.login) 
     @service= player.serviceid
     @a=Service.find(:first,:conditions=>["serviceid=?",@service]) 
    worksheet.write(current_row, 4, @a.servicename) 
    worksheet.write(current_row, 5, player.generatedtime.strftime("%H:%M:%S")) 
    if (player.calledtime!=nil)
      worksheet.write(current_row, 6, player.calledtime.strftime("%H:%M:%S")) 
    end

    worksheet.write(current_row, 7, player.counterno)
    if player.waittime!=nil
      worksheet.write(current_row, 8, player.waittime.strftime("%H:%M:%S")) 
    end
    if player.servicedtime!=nil 
      worksheet.write(current_row, 9, player.servicedtime.strftime("%H:%M:%S"))
    end
    if player.timetaken!=nil
      worksheet.write(current_row, 10, player.timetaken.strftime("%H:%M:%S"))
    end

     @status= player.tokenstatus 
    if ((@status=="0"))
      worksheet.write(current_row, 11, "Not Served")
    elsif(@status=="1")
      worksheet.write(current_row, 11, "served")
    elsif(@status=="3")
      worksheet.write(current_row, 11, "Missed")
    end      
    current_row=current_row+1
     current_row
  end
   footer_row=current_row
   
   
    worksheet.write(footer_row,6,@mean,header_format)
    
    footer_row=footer_row+1    
										
  

workbook.close
pw=Dir.pwd()
        Dir.chdir(pw)
        filename=pw.to_s+"/"+spreadsheet_file
	   
    send_file(filename,
      :disposition => 'attachment',
      :encoding => 'utf8',
      :type => 'application/octet-stream')
  end
  
  
   # >>--------------------------------> Extra Master For Today's Date <-------------------------------------------<< 
 def Masterreporth1 
 
 spreadsheet_file="MasterreportToday's.csv"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
@count=0
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>20)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()
workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)

worksheet.write(0, 3, 'Detailed Master Report For Todays Date', page_header_format)
current_row=3
 header_row=2
 footer_row=0
current_row=current_row+1
 
  @count=0 
  @master=Transact.find_by_sql("select distinct serviceid,tokenno,transdate,generatedtime,login,calledtime,counterno,waittime,servicedtime,timetaken,tokenstatus
						from transacts
						where transdate=CURDATE( ) 
    						and (tokenstatus=0 or tokenstatus=1 or tokenstatus=3 )") 
   
              header_row=footer_row+2
              header_row=header_row+2
              worksheet.write(header_row, 0, ['Sr.No.','Token No','Date','Teller Name','Service Name','Generated Time','Called Time','Counter','Wait Time','Serviced Time','Timetaken','Tokenstatus'], header_format)
              current_row=header_row+2
            		 
   @master.each do |player|

    worksheet.write(current_row, 0, @count=@count+1)
    worksheet.write(current_row, 1, player.tokenno)     
    worksheet.write(current_row, 2, player.transdate.strftime("%d/%m/%Y"))  
    worksheet.write(current_row, 3, player.login) 
     @service= player.serviceid
     @a=Service.find(:first,:conditions=>["serviceid=?",@service]) 
    worksheet.write(current_row, 4, @a.servicename) 
    worksheet.write(current_row, 5, player.generatedtime.strftime("%H:%M:%S")) 
    if (player.calledtime!=nil)
      worksheet.write(current_row, 6, player.calledtime.strftime("%H:%M:%S")) 
    end

    worksheet.write(current_row, 7, player.counterno)
    if player.waittime!=nil
      worksheet.write(current_row, 8, player.waittime.strftime("%H:%M:%S")) 
    end
    if player.servicedtime!=nil 
      worksheet.write(current_row, 9, player.servicedtime.strftime("%H:%M:%S"))
    end
    if player.timetaken!=nil
      worksheet.write(current_row, 10, player.timetaken.strftime("%H:%M:%S"))
    end

     @status= player.tokenstatus 
    if ((@status=="0"))
      worksheet.write(current_row, 11, "InQueue")
    elsif(@status=="1")
      worksheet.write(current_row, 11, "Served")
    elsif(@status=="3")
      worksheet.write(current_row, 11, "Missed")
    end      
    current_row=current_row+1
     current_row
  end
   footer_row=current_row
   
   
    worksheet.write(footer_row,6,@mean,header_format)
    
    footer_row=footer_row+1    
										
  

workbook.close
pw=Dir.pwd()
        Dir.chdir(pw)
        filename=pw.to_s+"/"+spreadsheet_file
	   
    send_file(filename,
      :disposition => 'attachment',
      :encoding => 'utf8',
      :type => 'application/octet-stream')
 end
 
 # >>--------------------------------> Report5 <-------------------------------------------<< 
def Missingppendingtoken
@date=params[:startdate]
  
spreadsheet_file="Missingpendingtoken.xls"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
@count=0
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>20)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()
workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)

worksheet.write(0, 3, 'Missing Pending Token ', page_header_format)
 current_row=3
 header_row=2
 footer_row=0
current_row=current_row+1
 
 if params[:startdate].to_date == Date.today  
        worksheet.write(1, 0, ['Date:'],header_format)
        worksheet.write(1,1,@date,header_format)
        
        @data=Service.find_by_sql("select  tokenno,transdate,generatedtime,calledtime,serviceid,login,counterno
												from transacts
												where transdate='#{params[:startdate]}' and tokenstatus=0") 

	           


            if @data != [] 
 
             @count = 0
                
             header_row=footer_row+2
              p "********** #{header_row}"
              worksheet.write(header_row, 0, ['For:'],header_format)
              worksheet.write(header_row,1,'Pending',header_format)
                header_row=header_row+2
                p "&&&&&&& #{header_row}"
              worksheet.write(header_row, 0, ['Sr.No','Tokenno','Transaction date','Generatedtime','Calledtime','Serviceid','Login','Counterno'], header_format)
              current_row=header_row+2
              p "********** #{current_row}"
			  @data.each do |c|


    worksheet.write(current_row, 0, @count=@count+1)
    worksheet.write(current_row, 1, c.tokenno) 
    worksheet.write(current_row, 2, c.transdate)  
    worksheet.write(current_row, 3, c.generatedtime) 
    worksheet.write(current_row, 4, c.calledtime)
    Service.find(:all, :conditions => ["serviceid=?",c.serviceid]).each do |d| 
		@servicename=d.servicename
    end 
    worksheet.write(current_row, 5, @servicename) 
    worksheet.write(current_row, 6, c.login) 
    worksheet.write(current_row, 7,  c.counterno)
    current_row=current_row+1
    p current_row
   end
    @data1=Service.find_by_sql("select  tokenno,transdate,generatedtime,calledtime,serviceid,login,counterno
												from transacts
												where transdate='#{params[:startdate]}' and tokenstatus=3")
            if @data1 != [] 
              header_row=current_row+2
              p "********** #{header_row}"
              worksheet.write(header_row, 0, ['For:'],header_format)
              worksheet.write(header_row,1,'Missing',header_format)
                header_row=header_row+2
                p "&&&&&&& #{header_row}"
              worksheet.write(header_row, 0, ['Sr.No','Tokenno','Transaction date','Generatedtime','Calledtime','Serviceid','Login','Counterno'], header_format)
              current_row=header_row+2
              p "********** #{current_row}"
			  @data1.each do |c|


    worksheet.write(current_row, 0, @count=@count+1)
    worksheet.write(current_row, 1, c.tokenno) 
    worksheet.write(current_row, 2, c.transdate)  
    worksheet.write(current_row, 3, c.generatedtime) 
    worksheet.write(current_row, 4, c.calledtime)
    Service.find(:all, :conditions => ["serviceid=?",c.serviceid]).each do |d| 
		@servicename=d.servicename
    end 
    worksheet.write(current_row, 5, @servicename) 
    worksheet.write(current_row, 6, c.login) 
    worksheet.write(current_row, 7,  c.counterno)
    current_row=current_row+1
    p current_row
   end
   								
  end  
end
else
     worksheet.write(1, 0, ['Date:'],header_format)
        worksheet.write(1,1,@date,header_format)
        
        @data=Service.find_by_sql("select  tokenno,transdate,generatedtime,calledtime,serviceid,login,counterno
												from transactmaster
												where transdate='#{params[:startdate]}' and tokenstatus=0") 

	        if @data != [] 
 
             @count = 0
                
             header_row=footer_row+2
              p "********** #{header_row}"
              worksheet.write(header_row, 0, ['For:'],header_format)
              worksheet.write(header_row,1,'Pending',header_format)
                header_row=header_row+2
                p "&&&&&&& #{header_row}"
              worksheet.write(header_row, 0, ['Sr.No','Tokenno','Transaction date','Generatedtime','Calledtime','Serviceid','Login','Counterno'], header_format)
              current_row=header_row+2
              p "********** #{current_row}"
			  @data.each do |c|


    worksheet.write(current_row, 0, @count=@count+1)
    worksheet.write(current_row, 1, c.tokenno) 
    worksheet.write(current_row, 2, c.transdate)  
    worksheet.write(current_row, 3, c.generatedtime) 
    worksheet.write(current_row, 4, c.calledtime)
    Service.find(:all, :conditions => ["serviceid=?",c.serviceid]).each do |d| 
		@servicename=d.servicename
    end 
    worksheet.write(current_row, 5, @servicename) 
    worksheet.write(current_row, 6, c.login) 
    worksheet.write(current_row, 7,  c.counterno)
    current_row=current_row+1
    p current_row
   end
    @data1=Service.find_by_sql("select  tokenno,transdate,generatedtime,calledtime,serviceid,login,counterno
												from transactmaster
												where transdate='#{params[:startdate]}' and tokenstatus=3")
            if @data1 != [] 
              header_row=current_row+2
              p "********** #{header_row}"
              worksheet.write(header_row, 0, ['For:'],header_format)
              worksheet.write(header_row,1,'Missing',header_format)
                header_row=header_row+2
                p "&&&&&&& #{header_row}"
              worksheet.write(header_row, 0, ['Sr.No','Tokenno','Transaction date','Generatedtime','Calledtime','Serviceid','Login','Counterno'], header_format)
              current_row=header_row+2
              p "********** #{current_row}"
			  @data1.each do |c|


    worksheet.write(current_row, 0, @count=@count+1)
    worksheet.write(current_row, 1, c.tokenno) 
    worksheet.write(current_row, 2, c.transdate)  
    worksheet.write(current_row, 3, c.generatedtime) 
    worksheet.write(current_row, 4, c.calledtime)
    Service.find(:all, :conditions => ["serviceid=?",c.serviceid]).each do |d| 
		@servicename=d.servicename
    end 
    worksheet.write(current_row, 5, @servicename) 
    worksheet.write(current_row, 6, c.login) 
    worksheet.write(current_row, 7,  c.counterno)
    current_row=current_row+1
    p current_row
   end
   								
  end  
end
end    
workbook.close
pw=Dir.pwd()
        Dir.chdir(pw)
        filename=pw.to_s+"/"+spreadsheet_file
	   
    send_file(filename,
      :disposition => 'attachment',
      :encoding => 'utf8',
      :type => 'application/octet-stream')
  end
   # >>--------------------------------> Report6 <-------------------------------------------<< 
def MonthWiseusersummery
 p params[:month] 
spreadsheet_file="MonthWiseusersummery.xls"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
@count=0
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>20)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()
workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)

worksheet.write(0, 3, 'Month Wise User Summery', page_header_format)
 current_row=3
 header_row=2
 footer_row=0
current_row=current_row+1

  p @a=params[:month] 
 			 @abc=Service.find_by_sql("select date_format(transdate,'%M')as Monthname from transactmaster
											where month(transdate)='#{@a}' ") 
		
			 if @abc[0]==nil
			   puts  "No Data Found" 
             else 						
				@monthname=@abc[0].Monthname
 			    @b=params[:year] 
                
        	@data=Service.find_by_sql("select login,ctypeid,count(tokenno) as tokenno ,avg(time_to_sec(timetaken)) as timeavg,avg(time_to_sec(waittime)) as waitavg,sum(score),CONCAT_WS(' ',sum(score),'/',count(tokenno)*10,' ', format(sum(score)/count(tokenno)*10,0),'%') as percentage
											from transactmaster
											where month(transdate)='#{@a}' and year(transdate)='#{@b}' and tokenstatus=1
											group by ctypeid") 
        

 
             if @data != [] 
 
             @count = 0
                  
             header_row=footer_row+2
              p "********** #{header_row}"
              worksheet.write(header_row, 0, @monthname,header_format)
              worksheet.write(header_row,1,@b,header_format)
                header_row=header_row+2
                p "&&&&&&& #{header_row}"
              worksheet.write(header_row, 0, ['Teller Nmae','Customer Type','Token Served','Avg Time To Served','Avg Waittime','Employee Score %'], header_format)
              current_row=header_row+2
              p "********** #{current_row}"
			  @data.each do |c|


    worksheet.write(current_row, 0, c.login)
     Customertype.find(:all, :conditions => ["ctypeid=?", c.ctypeid]).each do |d| 
                 
    worksheet.write(current_row, 1,d.ctypedesc) 
    
                 end
    worksheet.write(current_row, 2, c.tokenno) 
     seconds   =  c.timeavg.to_i % 60
								c.timeavg = (c.timeavg.to_i - seconds.to_i) / 60
								minutes    =  c.timeavg.to_i % 60
								c.timeavg = (c.timeavg.to_i - minutes.to_i) / 60
								hours      =  c.timeavg.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end
								
								@avgt="#{hours}:#{minutes}:#{seconds}" 
    
    worksheet.write(current_row, 3, @avgt)
      seconds   =  c.waitavg.to_i % 60
								c.waitavg = (c.waitavg.to_i - seconds.to_i) / 60
								minutes    =  c.waitavg.to_i % 60
								c.waitavg = (c.waitavg.to_i - minutes.to_i) / 60
								hours      =  c.waitavg.to_i % 24
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								@avgw= "#{hours}:#{minutes}:#{seconds}" 
    
    worksheet.write(current_row, 4, @avgw) 
    worksheet.write(current_row, 5, c.percentage) 
    current_row=current_row+1
    p current_row
  end
   footer_row=current_row
   
   p "@@@@@ #{footer_row}"
   @abc=Service.find_by_sql("select count(tokenno) as tokenno
										from transactmaster
										where month(transdate)='#{@a}' and tokenstatus=1 and year(transdate)='#{@b}' ") 
										
		
	worksheet.write(footer_row, 0, ['Token Served'],header_format)
    worksheet.write(footer_row,1,@abc[0].tokenno,header_format)
    
    @abc=Service.find_by_sql("select avg(time_to_sec(timetaken)) as timetaken
										from transactmaster
										where month(transdate)='#{@a}' and tokenstatus=1 and year(transdate)='#{@b}' ") 
										
								 seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
											
								@avgt= "#{hours}:#{minutes}:#{seconds}" 
    worksheet.write(footer_row, 2, ['Avg Mean Time to Serve'],header_format)
    worksheet.write(footer_row,3,@avgt,header_format)
    
  @abc=Service.find_by_sql("select avg(time_to_sec(waittime)) as timetaken
										from transactmaster
										where month(transdate)='#{@a}' and tokenstatus=1 and year(transdate)='#{@b}' ") 
										
								 seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								@avgw= "#{hours}:#{minutes}:#{seconds}" 
    worksheet.write(footer_row, 5, ['Avg Wait Time'],header_format)
    worksheet.write(footer_row,6,@avgw,header_format)
    
    
    footer_row=footer_row+1    
										
 end 
end                                    
workbook.close
pw=Dir.pwd()
        Dir.chdir(pw)
        filename=pw.to_s+"/"+spreadsheet_file
	   
    send_file(filename,
      :disposition => 'attachment',
      :encoding => 'utf8',
      :type => 'application/octet-stream')
  end
  # >>--------------------------------> Report7 <-------------------------------------------<< 
def Servicewisesummaryreport
   params[:startdate]
   params[:enddate] 
  
spreadsheet_file="Servicewisesummaryreport.xls"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
@count=0
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>20)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()
workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)

worksheet.write(0, 3, 'Service Wise Summary Report ', page_header_format)
 current_row=3
 header_row=2
 footer_row=0
current_row=current_row+1
 
 if params[:startdate].to_date == Date.today  and params[:enddate].to_date == Date.today  
         
   	@t = Service.find_by_sql("select distinct(counterno) as a1
						from transacts
						where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' order by counterno") 
		 @t.each do|a| 
		 @ctypeid = a.a1 
		   @s = Service.find_by_sql("select distinct(serviceid) as b1 
								from transacts 
								where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and ctypeid='#{@ctypeid}'
								order by ctypeid")  
			
          if @s !=[] 
              
             Customertype.find(:all, :conditions => ["ctypeid=?",@ctypeid]).each do |d| 
				@custname= d.ctypedesc 
             end 

              	 header_row=footer_row+2
               "********** #{header_row}"
              worksheet.write(header_row, 0, ['For:'],header_format)
              worksheet.write(header_row,1,@custname,header_format)
                header_row=header_row+2
                 "&&&&&&& #{header_row}"
              worksheet.write(header_row, 0, ['Service Name','Token Served','Not Served','Avg Time to Served','Avg Waittime'], header_format)
              current_row=header_row+2
              p "********** #{current_row}"        
               @s.each do|b| 
					 @serviceid = b.b1 

	
		             	@data=Service.find_by_sql("select serviceid,count(tokenno) as tokenno,avg(time_to_sec(timetaken)) as timetaken,avg(time_to_sec(waittime)) as waittime
														from transacts 
														where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' 
														and ctypeid=#{@ctypeid}  and serviceid='#{@serviceid}'
														group by serviceid ") 
		

            
 
             
			  @data.each do |c|

    Service.find(:all, :conditions => ["serviceid=?",c.serviceid]).each do |d| 
		@servicename= d.servicename 
	    end 
    worksheet.write(current_row, 0, @servicename)
    	@d=Service.find_by_sql("select count(tokenno) as tokenno
														from transacts
														where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' 
														and ctypeid=#{@ctypeid} and tokenstatus=1  and serviceid='#{@serviceid}'") 

               
    worksheet.write(current_row, 1, @d[0].tokenno) 
    	@data1=Service.find_by_sql("select count(tokenno) as tokenno
														from transacts 
														where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' 
														and ctypeid=#{@ctypeid} and tokenstatus!=1 and serviceid='#{@serviceid}'
														 ") 
				@data1.each do |d|
				@notserved=d.tokenno  
				 end   
    worksheet.write(current_row, 2, @notserved) 
	@a=Service.find_by_sql("select avg(time_to_sec(timetaken)) as timetaken,avg(time_to_sec(waittime)) as waittime,tokenstatus  
														from transacts
														where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' 
														and ctypeid=#{@ctypeid}  and serviceid='#{@serviceid}'  and tokenstatus=1
														group by serviceid ") 
						 if @a == [] 						
                            worksheet.write(current_row, 3, '00:00:00') 
			    		
						 else 									
		         	        @a.each do |c|
    
                            seconds   = c.timetaken.to_i % 60
								c.timetaken = (c.timetaken.to_i - seconds.to_i) / 60
								minutes    =  c.timetaken.to_i % 60
								c.timetaken = (c.timetaken.to_i - minutes.to_i) / 60
								hours      =  c.timetaken.to_i % 24
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								@timet= "#{hours}:#{minutes}:#{seconds}" 

                         worksheet.write(current_row, 3, @timet) 
                        end
                    end
                    
             if @a == []						
                worksheet.write(current_row, 4, '00:00:00') 
			    		
			 else 										
		         @a.each do |c|

                            seconds   = c.waittime.to_i % 60
								c.waittime = (c.waittime.to_i - seconds.to_i) / 60
								minutes    =  c.waittime.to_i % 60
								c.waittime = (c.waittime.to_i - minutes.to_i) / 60
								hours      =  c.waittime.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								@wait= "#{hours}:#{minutes}:#{seconds}" 
            worksheet.write(current_row, 4, @wait) 
           end
        end        

    current_row=current_row+1
     current_row

 end 

end
   footer_row=current_row
   
    "@@@@@ #{footer_row}"
        @abc=Service.find_by_sql("select count(tokenno) as ttoken
										from transacts 
										where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' 
										and ctypeid=#{@ctypeid} and tokenstatus=1")
											
	worksheet.write(footer_row, 0, ['Token Served'],header_format)
    worksheet.write(footer_row,1,@abc[0].ttoken,header_format)
        @abc=Service.find_by_sql("select count(tokenno) as ttoken
										from transacts	
                                        where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' 
										and ctypeid=#{@ctypeid} and tokenstatus!=1") 
										
	worksheet.write(footer_row, 2, ['Not Served'],header_format)
    worksheet.write(footer_row,3,@abc[0].ttoken,header_format)									

        @abc=Service.find_by_sql("select avg(time_to_sec(timetaken)) as timetaken,avg(time_to_sec(waittime))as waittime
										from transacts 
										where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' 
										and ctypeid=#{@ctypeid} and tokenstatus=1") 

								seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								
								@avgt= "#{hours}:#{minutes}:#{seconds}" 
    worksheet.write(footer_row, 4, ['Avg Mean Time to Serve'],header_format)
    worksheet.write(footer_row,5,@avgt,header_format)
         seconds   =  @abc[0].waittime.to_i % 60
								@abc[0].waittime = (@abc[0].waittime.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].waittime.to_i % 60
								@abc[0].waittime = (@abc[0].waittime.to_i - minutes.to_i) / 60
								hours      =  @abc[0].waittime.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								@avgwait= "#{hours}:#{minutes}:#{seconds}"     
        worksheet.write(footer_row, 4, ['Avg Waittime'],header_format)
        worksheet.write(footer_row,5,@avgwait,header_format)
    footer_row=footer_row+1    
										
 
end
end

else
        
   	@t = Service.find_by_sql("select distinct(counterno) as a1
						from transactmaster
						where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' order by counterno") 
		 @t.each do|a| 
		 @ctypeid = a.a1 
		   @s = Service.find_by_sql("select distinct(serviceid) as b1 
								from transactmaster
								where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and ctypeid='#{@ctypeid}'
								order by ctypeid")  
			
          if @s !=[] 
              
             Customertype.find(:all, :conditions => ["ctypeid=?",@ctypeid]).each do |d| 
				@custname= d.ctypedesc 
             end 

              	 header_row=footer_row+2
              p "********** #{header_row}"
              worksheet.write(header_row, 0, ['For:'],header_format)
              worksheet.write(header_row,1,@custname,header_format)
                header_row=header_row+2
                p "&&&&&&& #{header_row}"
              worksheet.write(header_row, 0, ['Service Name','Token Served','Not Served','Avg Time to Served','Avg Waittime'], header_format)
              current_row=header_row+2
               "********** #{current_row}"        
               @s.each do|b| 
					 @serviceid = b.b1 

	
		             	@data=Service.find_by_sql("select serviceid,count(tokenno) as tokenno,avg(time_to_sec(timetaken)) as timetaken,avg(time_to_sec(waittime)) as waittime
														from transactmaster 
														where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' 
														and ctypeid=#{@ctypeid}  and serviceid='#{@serviceid}'
														group by serviceid ") 
		

            
 
             
			  @data.each do |c|

    Service.find(:all, :conditions => ["serviceid=?",c.serviceid]).each do |d| 
		@servicename= d.servicename 
	    end 
    worksheet.write(current_row, 0, @servicename)
         	@d=Service.find_by_sql("select count(tokenno) as tokenno
														from transactmaster 
														where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' 
														and ctypeid=#{@ctypeid} and tokenstatus=1  and serviceid='#{@serviceid}'") 


    worksheet.write(current_row, 1, @d[0].tokenno) 
    	@data1=Service.find_by_sql("select count(tokenno) as tokenno
														from transactmaster
														where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' 
														and ctypeid=#{@ctypeid} and tokenstatus!=1 and serviceid='#{@serviceid}'
														") 
				@data1.each do |d|
				@notserved=d.tokenno  
				 end   
    worksheet.write(current_row, 2, @notserved)

       @a=Service.find_by_sql("select avg(time_to_sec(timetaken)) as timetaken,avg(time_to_sec(waittime)) as waittime,tokenstatus  
														from transactmaster 
														where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' 
														and ctypeid=#{@ctypeid}  and serviceid='#{@serviceid}'  and tokenstatus=1
														group by serviceid ") 
			if @a == [] 							
                worksheet.write(current_row, 3, '00:00:00')
			    		
			else								
		         @a.each do |c|
                    seconds   = c.timetaken.to_i % 60
								c.timetaken = (c.timetaken.to_i - seconds.to_i) / 60
								minutes    =  c.timetaken.to_i % 60
								c.timetaken = (c.timetaken.to_i - minutes.to_i) / 60
								hours      =  c.timetaken.to_i % 24
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								@timet= "#{hours}:#{minutes}:#{seconds}" 
                            worksheet.write(current_row, 3, @timet) 
                end                
            end                

     if @a == [] 						
             worksheet.write(current_row, 4, '00:00:00') 
			    		
     else 									
		    @a.each do |c|

                seconds   = c.waittime.to_i % 60
								c.waittime = (c.waittime.to_i - seconds.to_i) / 60
								minutes    =  c.waittime.to_i % 60
								c.waittime = (c.waittime.to_i - minutes.to_i) / 60
								hours      =  c.waittime.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								@wait= "#{hours}:#{minutes}:#{seconds}" 
            worksheet.write(current_row, 4, @wait) 
         end     
      end
    current_row=current_row+1
    p current_row

 end 

end
   footer_row=current_row
   
    "@@@@@ #{footer_row}"
        @abc=Service.find_by_sql("select count(tokenno) as ttoken
										from transactmaster 
										where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' 
										and ctypeid=#{@ctypeid} and tokenstatus=1")
											
	worksheet.write(footer_row, 0, ['Token Served'],header_format)
    worksheet.write(footer_row,1,@abc[0].ttoken,header_format)
        @abc=Service.find_by_sql("select count(tokenno) as ttoken
										from transactmaster																where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' 
										and ctypeid=#{@ctypeid} and tokenstatus!=1") 
										
	worksheet.write(footer_row, 2, ['Not Served'],header_format)
    worksheet.write(footer_row,3,@abc[0].ttoken,header_format)									

        @abc=Service.find_by_sql("select avg(time_to_sec(timetaken)) as timetaken,avg(time_to_sec(waittime))as waittime
										from transactmaster
										where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' 
										and ctypeid=#{@ctypeid} and tokenstatus=1") 

								seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								
								@avgt= "#{hours}:#{minutes}:#{seconds}" 
    worksheet.write(footer_row, 4, ['Avg Mean Time to Serve'],header_format)
    worksheet.write(footer_row,5,@avgt,header_format)
         seconds   =  @abc[0].waittime.to_i % 60
								@abc[0].waittime = (@abc[0].waittime.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].waittime.to_i % 60
								@abc[0].waittime = (@abc[0].waittime.to_i - minutes.to_i) / 60
								hours      =  @abc[0].waittime.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								@avgwait= "#{hours}:#{minutes}:#{seconds}"     
        worksheet.write(footer_row, 6, ['Avg Waittime'],header_format)
        worksheet.write(footer_row,7,@avgwait,header_format)
    footer_row=footer_row+1    
										
 
end
end
 
end    
workbook.close
pw=Dir.pwd()
        Dir.chdir(pw)
        filename=pw.to_s+"/"+spreadsheet_file
	   
    send_file(filename,
      :disposition => 'attachment',
      :encoding => 'utf8',
      :type => 'application/octet-stream')
  end



  # >>--------------------------------> Report8 <-------------------------------------------<< 
  
  
def Servicewisebenchmarkreport
 p  params[:startdate]
 p  params[:enddate]
  
spreadsheet_file="Servicewisebenchmark.xls"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
@count=0
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>20)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()
workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)

worksheet.write(0, 3, 'Service Wise Benchmark Report', page_header_format)
 current_row=3
 header_row=2
 footer_row=0
current_row=current_row+1
 
 if params[:startdate].to_date == Date.today  and params[:enddate].to_date == Date.today 
  @t = Service.find_by_sql("select distinct(counterno) as a1
						from transacts
						where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'  order by counterno")  
		@t.each do|a| 
		@ctypeid = a.a1 
			
		 @s = Service.find_by_sql("select distinct(serviceid) as b1 
								from transacts 
								where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and ctypeid='#{@ctypeid}'
								order by ctypeid")  
				        
                @s.each do|b| 
				@serviceid = b.b1 

                Service.find(:all, :conditions => ["serviceid=?",@serviceid ]).each do |d| 
				    @servicename=d.servicename
                end 
                Customertype.find(:all, :conditions => ["ctypeid=?",@ctypeid]).each do |d| 
				    @ctypename = d.ctypedesc 
                end 
                Service.find(:all, :conditions => ["serviceid=?",@serviceid]).each do |d| 
				    @thresholdtime = d.thresholdtime.strftime("%H:%M:%S") 
                end 
                
                	@data=Service.find_by_sql("select tokenno,transdate,generatedtime,calledtime,servicedtime,login,counterno,waittime,timetaken,tokenstatus,format(((time_to_sec(timetaken)/time_to_sec(thresholdtime)))*100,0) as benchmark
										from transacts t1,services s1
										where t1.serviceid=s1.serviceid and t1.serviceid='#{@serviceid}' and ctypeid=#{@ctypeid}
										and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' ") 


                    @count = 0

             header_row=footer_row+2
              p "********** #{header_row}"
              worksheet.write(header_row, 1, ['service Name:'],header_format)
              worksheet.write(header_row,2,@servicename,header_format)
              worksheet.write(header_row, 4, ['For:'],header_format)
              worksheet.write(header_row,5,@ctypename,header_format)
              worksheet.write(header_row, 7, ['Threshold Time :'],header_format)
              worksheet.write(header_row,8,@thresholdtime,header_format)
                header_row=header_row+2
                p "&&&&&&& #{header_row}"
              worksheet.write(header_row, 0, ['Sr.No','Token No','Transdate','Generated Time','Calledtime','Serviced Time','Teller Name','Counter','Wait Time','Timetaken','Benchmark %','Tokenstatus'], header_format)
              current_row=header_row+2
              p "********** #{current_row}"
			  @data.each do |c|


    worksheet.write(current_row, 0, @count=@count+1)
    worksheet.write(current_row, 1, c.tokenno) 
    worksheet.write(current_row, 2, c.transdate)  
    worksheet.write(current_row, 3, c.generatedtime) 
    worksheet.write(current_row, 4, c.calledtime) 
    worksheet.write(current_row, 5, c.servicedtime) 
    worksheet.write(current_row, 6, c.login) 
    worksheet.write(current_row, 7,  c.counterno)
    worksheet.write(current_row, 8,  c.waittime)
    worksheet.write(current_row, 9,  c.timetaken)
     if c.tokenstatus.to_i == 1 
        worksheet.write(current_row, 11, "Served")
     else
        worksheet.write(current_row, 11,  "IN Q")
     end
    worksheet.write(current_row, 10,  c.benchmark)
        
    current_row=current_row+1
    p current_row
end
   footer_row=current_row
   
   p "@@@@@ #{footer_row}"
   @abc=Service.find_by_sql("select count(tokenno) as tokenno
										from transacts
										where serviceid='#{@serviceid}' and ctypeid=#{@ctypeid} and tokenstatus=1
										and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' ")
								
										
	worksheet.write(footer_row, 3, ['Token Served'],header_format)
    worksheet.write(footer_row,4,@abc[0].tokenno,header_format)
    
    @abc=Service.find_by_sql("select avg(time_to_sec(timetaken)) as timetaken
														from transacts
														where serviceid='#{@serviceid}' and ctypeid=#{@ctypeid} and tokenstatus=1
									                 and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'") 

							    seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
											
								
								@avgt= "#{hours}:#{minutes}:#{seconds}" 
    worksheet.write(footer_row, 6, ['Avg Mean Time to Serve'],header_format)
    worksheet.write(footer_row,7,@avgt,header_format)
    
    
    footer_row=footer_row+1    
	
end    
end  
else
    @t = Service.find_by_sql("select distinct(counterno) as a1
						from transactmaster
						where transdate>='#{params[:startdate]}'and transdate<='#{params[:enddate]}' order by counterno")  
         
		@t.each do |a| 
            @ctypeid = a.a1 
		  
		 @s = Service.find_by_sql("select distinct(serviceid) as b1 
								from transactmaster
								where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and ctypeid='#{@ctypeid}'
								order by ctypeid")  
				        
                @s.each do |b| 
				@serviceid = b.b1 

                Service.find(:all, :conditions => ["serviceid=?",@serviceid ]).each do |d| 
				    @servicename=d.servicename
                end 
                Customertype.find(:all, :conditions => ["ctypeid=?",@ctypeid]).each do |d| 
				    @ctypename = d.ctypedesc 
                end 
                Service.find(:all, :conditions => ["serviceid=?",@serviceid]).each do |d| 
				    @thresholdtime = d.thresholdtime.strftime("%H:%M:%S")  
                end 
                
                	@data=Service.find_by_sql("select tokenno,transdate,generatedtime,calledtime,servicedtime,login,counterno,waittime,timetaken,tokenstatus,format(((time_to_sec(timetaken)/time_to_sec(thresholdtime)))*100,0) as benchmark
										from transactmaster t1,services s1
										where t1.serviceid=s1.serviceid and t1.serviceid='#{@serviceid}' and ctypeid=#{@ctypeid}
										and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' ") 


                    @count = 0

             header_row=footer_row+2
              p "********** #{header_row}"
              worksheet.write(header_row, 1, ['service Name:'],header_format)
              worksheet.write(header_row,2,@servicename,header_format)
              worksheet.write(header_row, 4, ['For:'],header_format)
              worksheet.write(header_row,5,@ctypename,header_format)
              worksheet.write(header_row, 7, ['Threshold Time :'],header_format)
              worksheet.write(header_row,8,@thresholdtime,header_format)
                header_row=header_row+2
                p "&&&&&&& #{header_row}"
              worksheet.write(header_row, 0, ['Sr.No','Token No','Transdate','Generated Time','Calledtime','Serviced Time','Teller Name','Counter','Wait Time','Timetaken','Benchmark %','Tokenstatus'], header_format)
              current_row=header_row+2
              p "********** #{current_row}"
			  @data.each do |c|


    worksheet.write(current_row, 0, @count=@count+1)
    worksheet.write(current_row, 1, c.tokenno) 
    worksheet.write(current_row, 2, c.transdate)  
    worksheet.write(current_row, 3, c.generatedtime) 
    worksheet.write(current_row, 4, c.calledtime) 
    worksheet.write(current_row, 5, c.servicedtime) 
    worksheet.write(current_row, 6, c.login) 
    worksheet.write(current_row, 7,  c.counterno)
    worksheet.write(current_row, 8,  c.waittime)
    worksheet.write(current_row, 9,  c.timetaken)
     if c.tokenstatus.to_i == 1 
        worksheet.write(current_row, 11, "Served")
     else
        worksheet.write(current_row, 11,  "IN Q")
     end
    worksheet.write(current_row, 10,  c.benchmark)
        
    current_row=current_row+1
    p current_row
    end
   footer_row=current_row
   
   p "@@@@@ #{footer_row}"
   @abc=Service.find_by_sql("select count(tokenno) as tokenno
										from transactmaster
										where serviceid='#{@serviceid}' and ctypeid=#{@ctypeid} and tokenstatus=1
										and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' ")
								
										
	worksheet.write(footer_row, 3, ['Token Served'],header_format)
    worksheet.write(footer_row,4,@abc[0].tokenno,header_format)
    
    @abc=Service.find_by_sql("select avg(time_to_sec(timetaken)) as timetaken
														from transactmaster
														where serviceid='#{@serviceid}' and ctypeid=#{@ctypeid} and tokenstatus=1
									                 and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'") 

							    seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
											
								
								@avgt= "#{hours}:#{minutes}:#{seconds}" 
    worksheet.write(footer_row, 6, ['Avg Mean Time to Serve'],header_format)
    worksheet.write(footer_row,7,@avgt,header_format)
    
    
    footer_row=footer_row+1    
										
 
end
end 
end
workbook.close
pw=Dir.pwd()
        Dir.chdir(pw)
        filename=pw.to_s+"/"+spreadsheet_file
	   
    send_file(filename,
      :disposition => 'attachment',
      :encoding => 'utf8',
      :type => 'application/octet-stream')
  end
 
 
 
  # >>--------------------------------> Report9 <-------------------------------------------<< 
  
  
def Usersummery
 p  params[:startdate]
 p  params[:enddate]
  
spreadsheet_file="Usersummery.xls"
workbook=Excel.new(spreadsheet_file)
worksheet=workbook.add_worksheet
@count=0
page_header_format=Format.new(:color=>'black', :bold=>true, :size=>14)
player_name_format=Format.new(:color=>'black', :bold=>true,:size=>20)

header_format=Format.new(:color=>'blue', :bold=>true,:size=>10)
data_format=Format.new()
workbook.add_format(page_header_format)
workbook.add_format(player_name_format)
workbook.add_format(header_format)
workbook.add_format(data_format)

worksheet.write(0, 3, 'User Summery', page_header_format)
 current_row=3
 header_row=2
 footer_row=0
current_row=current_row+1
 
 if params[:startdate].to_date == Date.today  and params[:enddate].to_date == Date.today 
            @data=Service.find_by_sql("select login,ctypeid,count(tokenno) as tokenno ,avg(time_to_sec(timetaken)) as timeavg,avg(time_to_sec(waittime)) as waitavg,sum(score),CONCAT_WS(' ',sum(score),'/',count(tokenno)*10,' ',' ', format(sum(score)/count(tokenno)*10,0),'%') as percentage
											from transacts
											where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'  and tokenstatus=1
											group by login,ctypeid") 

              
            if @data != [] 
                        
				        
                

              header_row=footer_row+2
              p "********** #{header_row}"
               worksheet.write(header_row, 0, ['Teller Name','Customer Type','Token Served','Avg Time to Service','Avg Waittime','Employee Score %'], header_format)
              current_row=header_row+2
              p "********** #{current_row}"
			  @data.each do |c|
                  
    Customertype.find(:all, :conditions => ["ctypeid=?", c.ctypeid]).each do |d| 
       @custname=d.ctypedesc 
    end

    worksheet.write(current_row, 0, c.login )
    worksheet.write(current_row, 1,  @custname) 
    worksheet.write(current_row, 2,  c.tokenno)  
         seconds   =  c.timeavg.to_i % 60
								c.timeavg = (c.timeavg.to_i - seconds.to_i) / 60
								minutes    =  c.timeavg.to_i % 60
								c.timeavg = (c.timeavg.to_i - minutes.to_i) / 60
								hours      =  c.timeavg.to_i % 24
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								@avgserved= "#{hours}:#{minutes}:#{seconds}"  
    worksheet.write(current_row, 3, @avgserved)
         seconds   =  c.waitavg.to_i % 60
								c.waitavg = (c.waitavg.to_i - seconds.to_i) / 60
								minutes    =  c.waitavg.to_i % 60
								c.waitavg = (c.waitavg.to_i - minutes.to_i) / 60
								hours      =  c.waitavg.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								@avgwait= "#{hours}:#{minutes}:#{seconds}"  
    worksheet.write(current_row, 4, @avgwait) 
    worksheet.write(current_row,5, c.percentage)
    current_row=current_row+1
    p current_row
end
   footer_row=current_row
   
   p "@@@@@ #{footer_row}"
    @abc=Service.find_by_sql("select count(tokenno) as tokenno
										from  transacts
										where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and tokenstatus=1  ")
							
	worksheet.write(footer_row, 0, ['Token Served'],header_format)
    worksheet.write(footer_row,1,@abc[0].tokenno,header_format)
    
     @abc=Service.find_by_sql("select avg(time_to_sec(timetaken)) as timetaken
										from  transacts
										where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and tokenstatus=1  ") 
										
								 seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
							
								
								@avgt= "#{hours}:#{minutes}:#{seconds}" 
    worksheet.write(footer_row, 2, ['Avg Mean Time to Serve'],header_format)
    worksheet.write(footer_row,3,@avgt,header_format)
         @abc=Service.find_by_sql("select avg(time_to_sec(waittime)) as timetaken
										from  transacts
										where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'and tokenstatus=1  ") 
										
								seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 

								
								@avgwait= "#{hours}:#{minutes}:#{seconds}"  

    worksheet.write(footer_row, 4, ['Avg Mean Time to Serve'],header_format)
    worksheet.write(footer_row,5,@avgwait,header_format)
    
    footer_row=footer_row+1    
	
end  
else
    @data=Service.find_by_sql("select login,ctypeid,count(tokenno) as tokenno ,avg(time_to_sec(timetaken)) as timeavg,avg(time_to_sec(waittime)) as waitavg,sum(score),CONCAT_WS(' ',sum(score),'/',count(tokenno)*10,' ',' ', format(sum(score)/count(tokenno)*10,0),'%') as percentage
											from transactmaster
											where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'  and tokenstatus=1
											group by login,ctypeid") 

              
            if @data != [] 
                        
				        
                

              header_row=footer_row+2
              p "********** #{header_row}"
               worksheet.write(header_row, 0, ['Teller Name','Customer Type','Token Served','Avg Time to Service','Avg Waittime','Employee Score %'], header_format)
              current_row=header_row+2
              p "********** #{current_row}"
			  @data.each do |c|
                  
    Customertype.find(:all, :conditions => ["ctypeid=?", c.ctypeid]).each do |d| 
       @custname=d.ctypedesc 
    end

    worksheet.write(current_row, 0, c.login )
    worksheet.write(current_row, 1,  @custname) 
    worksheet.write(current_row, 2,  c.tokenno)  
         seconds   =  c.timeavg.to_i % 60
								c.timeavg = (c.timeavg.to_i - seconds.to_i) / 60
								minutes    =  c.timeavg.to_i % 60
								c.timeavg = (c.timeavg.to_i - minutes.to_i) / 60
								hours      =  c.timeavg.to_i % 24
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								@avgserved= "#{hours}:#{minutes}:#{seconds}"  
    worksheet.write(current_row, 3, @avgserved)
         seconds   =  c.waitavg.to_i % 60
								c.waitavg = (c.waitavg.to_i - seconds.to_i) / 60
								minutes    =  c.waitavg.to_i % 60
								c.waitavg = (c.waitavg.to_i - minutes.to_i) / 60
								hours      =  c.waitavg.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
								
								@avgwait= "#{hours}:#{minutes}:#{seconds}"  
    worksheet.write(current_row, 4, @avgwait) 
    worksheet.write(current_row,5, c.percentage)
    current_row=current_row+1
    p current_row
end
   footer_row=current_row
   
   p "@@@@@ #{footer_row}"
    @abc=Service.find_by_sql("select count(tokenno) as tokenno
										from  transactmaster
										where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and tokenstatus=1  ")
							
	worksheet.write(footer_row, 0, ['Token Served'],header_format)
    worksheet.write(footer_row,1,@abc[0].tokenno,header_format)
    
     @abc=Service.find_by_sql("select avg(time_to_sec(timetaken)) as timetaken
										from  transactmaster
										where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and tokenstatus=1  ") 
										
								 seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 
							
								
								@avgt= "#{hours}:#{minutes}:#{seconds}" 
    worksheet.write(footer_row, 2, ['Avg Mean Time to Serve'],header_format)
    worksheet.write(footer_row,3,@avgt,header_format)
         @abc=Service.find_by_sql("select avg(time_to_sec(waittime)) as timetaken
										from  transactmaster
										where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'and tokenstatus=1  ") 
										
								seconds   =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - seconds.to_i) / 60
								minutes    =  @abc[0].timetaken.to_i % 60
								@abc[0].timetaken = (@abc[0].timetaken.to_i - minutes.to_i) / 60
								hours      =  @abc[0].timetaken.to_i % 24 
								
								if(hours<10)
									hours="0#{hours}"
								end

								if(minutes<10)
									minutes="0#{minutes}"
								end

								if(seconds<10)
									seconds="0#{seconds}"
								end 

								
								@avgwait= "#{hours}:#{minutes}:#{seconds}"  

    worksheet.write(footer_row, 4, ['Avg Mean Time to Serve'],header_format)
    worksheet.write(footer_row,5,@avgwait,header_format)
    
    footer_row=footer_row+1    
	
end  
end
workbook.close
pw=Dir.pwd()
        Dir.chdir(pw)
        filename=pw.to_s+"/"+spreadsheet_file
	   
    send_file(filename,
      :disposition => 'attachment',
      :encoding => 'utf8',
      :type => 'application/octet-stream')
  end



end
