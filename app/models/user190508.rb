#An unpublished work of Sprylogic Technologies Ltd. 
# © Copyright Sprylogic Technologies Ltd. 2008. All rights reserved 

require 'digest/sha1'

# this model expects a certain database layout and its based on the name/login pattern. 
class User < ActiveRecord::Base
     acts_as_reportable

def self.time
     @counter=User.find_first(["login=?",@session['user']['login']])
      @transact= Transact.find_first([" counterno=?  ",@counter.counterno])     
     @t= Stp.find_first(["stpname=?",@transact.stpname])
     @time= @t.servicetime.strftime("%H:%M:%S")
     #p 'service time '+@time
    begin     
    @gvar=@gvar+1 
    if @gvar>60
     @b=@b+1
     @gvar=0
     #  page<< "00:0#{$b}:#{$gvar}"
     @c="00:0#{@b}:#{@gvar}"
      #p 'if'+ @c
    @u=render :text=> "00:0#{@b}:#{@gvar}" 
  else
    @b="00:0#{@b}:#{@gvar}"  
    #p  'else'+@b
   if @b > @time
     #p 'time over'  
     @p=render :text=> '<font color=red size=4><b>'+"00:0#{@b}:#{@gvar}" +'</b></font>'
    #@u=render :text=> "00:0#{$b}:#{$gvar} time over"
  end
  @p=render :text=>"00:0#{@b}:#{@gvar}" 
  end
 $tot_diff=10
 if @gvar>10
   #page.alert "hh"
     #page << "document.getElementById('time_div').style.color = 'red'"
   #page[:time_div].set_style :color=>'red'
 #end
 end 
 rescue Exception => exc
     
     STDERR.puts "Error is #{exc.message}"
     end  
   end
   
  def self.authenticate(login, pass)
    find_first(["login = ? AND password = ?", login, sha1(pass)])
  end  

  def change_password(pass)
    update_attribute "password", self.class.sha1(pass)
  end
    
 def self.login_type(login,pass)
   find_first(["login = ? and password= ?",login,sha1(pass)])
 end
 

  def self.sha1(pass)
    Digest::SHA1.hexdigest("change-me--#{pass}--")
  end
    
  before_create :crypt_password
  
  def crypt_password
    write_attribute("password", self.class.sha1(password))
  end

def password_check?(pass)
   self.password == self.class.sha1(pass)
 end
 

def self.time_diff_in_minutes (time1,time2)
  @s=time2
  @r=time1.strftime("%H:%M:%S")
  
  
  # diff of hours
  @diff_hour = (@s.hour() - time1.hour())
  if @diff_hour<0
    @diff_hour= (time1.hour() - @s.hour())
  end

  # diff of min
  @diff_min = (@s.min() - time1.min())
  if @diff_min<0
    @diff_min= (time1.min() - @s.min())
  end

  # diff of sec
  @diff_sec= (@s.sec() - time1.sec())
  if @diff_sec<0
    @diff_sec= (time1.sec() - @s.sec())
  end
#p "TIME1=#{@r} time2=#{@s}"
  #p "hour =#{@diff_hour} min=#{@diff_min} sec=#{@diff_sec}"
  waittime="#{@diff_hour}:#{@diff_min}:#{@diff_sec}"
  return waittime
end

def self.time_diff(time1,time2)
hour=(time2.hour() - time1.hour())
min =(time2.min() - time1.min())
sec= (time2.sec() - time1.sec())
w="#{hour} :#{min}: #{sec}"
return w
end



has_many :services
validates_length_of :login, :within => 5..10, :on => :create
validates_length_of :password, :within => 5..10, :on => :create
  validates_presence_of :login, :password,  :on => :create
 validates_uniqueness_of :login, :on => :create
  validates_confirmation_of :password, :on => :create  
  validates_presence_of :usertype, :on => :create
 
  validates_presence_of :firstname, :on => :create
  validates_presence_of :lastname, :on => :create
  validates_presence_of :login, :on => :create
  validates_presence_of :password, :on => :create
  
end
