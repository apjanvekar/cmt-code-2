class Abc 
def displaydetails
@t= Account.find(:all)
@t.each do |c|
puts "#{c.accountno}"
end
end
def shutdown
  puts "hello"
  command="calc"
  #command = "shutdown -s"
  system(command)
end

def index
  require 'C:\ROR\InstantRails\rails_apps\DQMS\lib\mysql'
  mysql = Mysql.init()
  mysql.connect('132.147.160.123','ssp','ssp')
  mysql.select_db('DQMS_development')
  results = mysql.query("SELECT name from Accounts")

  #puts "#{@results[0].ss}"
 
  results.each{|row|; puts row; }

end

a=Abc.new
a.index
end