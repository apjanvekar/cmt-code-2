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
  def validate_password(password)
      reg = /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){8,40}$/
      return (reg.match(password))? true : false
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
    
  def new_password
   puts "@params['new_password']"
  end    
  
  def crypt_password
    write_attribute("password", self.class.sha1(password))
  end

def password_check?(pass)
   self.password == self.class.sha1(pass)
 end
 @sec="0"
 @min="0"
 @hour="0"
 
def self.time_diff_in_minutes_old(time1,time2)
 begin 
require 'time'
require 'date'

puts time1
time1=time1.strftime("%H:%M:%S")
time2=time2.strftime("%H:%M:%S")
t1=Time.parse(time1)
t2=Time.parse(time2)

@sec = t2 - t1     # diff in seconds

while(@sec.to_i>=60) 
@sec=@sec.to_i-60
@min=@min.to_i+1
break if@sec.to_i<60
end

while(@min.to_i>=60) 
@min=@min.to_i-60
@hour=@hour.to_i+1
break if@min.to_i<60
end
if(@hour.to_i<=10)
  
  @hour="0#{@hour}"
  #puts "min is #{@hour}"
  else 
    #puts "sss"
  end
  
if(@min.to_i<=10)
  puts "min is #{@min}"
  @min="0#{@min}"
  puts "min is #{@min}"
  else 
    puts "sss"
  end
  if(@sec.to_i<=10)
  #puts "min is #{@min}"
  @sec="0#{@sec}"
  #puts "min is #{@min}"
  else 
    #puts "sss"
end
   
diff="#{@hour}:#{@min}:#{@sec}"
p"--------------------------------"
p "difference in model=#{diff}"
p"-------------------------------------"
return diff
rescue Exception => exc
    
    #STDERR.puts "Error is #{exc.message}"
  end
  
end
def self.time_diff_in_minutes(time1,time2)
    difference=(Time.parse(time2.strftime("%H:%M:%S"))-Time.parse(time1.strftime("%H:%M:%S"))).to_i
    seconds    =  difference % 60
    difference = (difference - seconds) / 60
    minutes    =  difference % 60
    difference = (difference - minutes) / 60
    hours      =  difference % 24
    Time.parse("#{hours.to_i}:#{minutes.to_i}:#{seconds.to_i}").strftime("%H:%M:%S")
end

def self.time_diff_in_minutes1 (time1,time2)
  @s=time2
  @r=time1.strftime("%H:%M:%S")
 time_diff_in_minutes
  
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
=begin
  validates_uniqueness_of :login, :on => :create,  :message=>"Name already Exists"
  validates_uniqueness_of :login, :on => :update,  :message=>"Name already Exists"
  validates_presence_of :login, :on => :create, :message=>"Name Cannot be Blank"
  validates_presence_of :login, :on => :update, :message=>"Name Cannot be Blank"
  validates_length_of :login, :within => 5..10, :on => :create, :too_long => "Name Too Long (Maximum 10 characters)", :too_short => "Name Too Short (Minimum 5 characters)"
  validates_length_of :login, :within => 5..10, :on => :update, :too_long => "Name Too Long (Maximum 10 characters)", :too_short => "Name Too Short (Minimum 5 characters)"
  
  validates_presence_of :usertype, :on => :create
  validates_presence_of :usertype, :on => :update
  validates_presence_of :firstname, :on => :update
  validates_presence_of :lastname, :on => :update
  
  validates_presence_of :firstname, :on => :create
  validates_presence_of :lastname, :on => :create
  validates_presence_of :password, :on => :create
  validates_presence_of  :password,  :on => :update 
  validates_length_of :password, :within => 5..10, :on => :create
  validates_format_of :firstname, :with => /^([^\d\W]|[-])*$/
  validates_format_of :lastname, :with => /^([^\d\W]|[-])*$/
  validates_format_of :password,   :with => /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){8,40}$/, :on => :create, :message => "Password should contain atleast one integer,one alphabet,one special characters from 20 to 7E ascii values and minimum of 8 and maximum of 40 cahracters long ." 
  validates_format_of :login, :with =>/^[a-zA-Z . 0-9]+$/x
  validates_confirmation_of :password, :on => :create  
=end
end
