#An unpublished work of Sprylogic Technologies Ltd. 
# © Copyright Sprylogic Technologies Ltd. 2008. All rights reserved 

class BackupController < ApplicationController
  layout 'accounts'
  before_filter :login_required
 def backup 
  #!/usr/bin/env ruby
###############################################################################
# Configuration section, we set a few constants here and use them throughout 
# the file. Do not edit the other sections unless you can read very basic
# code.
###############################################################################
 
# MySQL Username
@USERNAME = 'root'
 
# MySQL Password
@PASSWORD = ''
 
# Get times starting with current time
@NOW = Time.now.strftime("%m-%d-%Y")
 
# As far back as we are going to backup in seconds I believe because we all know 
# that (3600*24)*7=604800 or at least all the poor CS bastards know.
@BACKUP_END = (Time.now - 604800).strftime("%m-%d-%Y")
 
# Filename to create only change the sqldump part. This could use two variables
# but I see no point I only made this config section to simplify but there is a
# limit, Rocky Dennis
@FILENAME = "sqldump-#{@NOW}.sql"
 
# Filename to remove, same as above just make sure it matches the same name 
# though or the cleanup won't really work.
@REMOVE_FILENAME = "sqldump-#{@BACKUP_END}.sql"
 
###############################################################################
# Here we will dump the database. I will include line comments above each  
# command to explain what it's purpose is.
###############################################################################
 
# The command that we want to start with to dump the databases
command = "mysqldump -u #{@USERNAME} --password=#{@PASSWORD} dqms_development >> #{@FILENAME}"
#command=  "mysqldump -u root --password= --all-databases >>dumpback.sql"
 
# Run the command that we just built with our config constants
system(command)
 
###############################################################################
# Here we will check to see if a file exists that is older than one week by the
# variable set earlier. If it exists then we will remove it. You could be crea-
# tive here and add it to a tar and then when you have 7 or so then GZip them
# creating an incremental backup of everything.
###############################################################################
 pw=Dir.pwd()
 Dir.chdir(pw)
 filename=pw.to_s+"/"+@FILENAME
 send_file(filename,
:disposition => 'attachment',
:encoding => 'utf8',
:type => 'application/octet-stream')
# Check if file exists and then remove it if it does
#if File.exists?(@REMOVE_FILENAME) 
#command = "rm #{removeFile}"
#command = "rm #{@REMOVE_FILENAME}"
#system(command)
#end
 

###############################################################################
# This is optional, if you run some sort of offsite backups and are sending 
# this to that location then you would want to scp them over. This will also 
# only work if you have setup keys to allow you login over ssh without typing
# a password. It is easy to setup and there are many tutorials. Just google for
# "ssh without password" Again you could make this use the config section but
# I figured most people wouldn't really use this part.
###############################################################################
# command = "scp #{FILENAME} user@192.168.1.1:SqlBackups/#{FILENAME}"
# system(command)
#redirect_to :controller=>"backup",:action => "backup1"
  end
  
  def shutdown
  #command = "shutdown -h now"
  #command=  "mysqldump - root --password= --all-databases >>dumpback.sql"
  #command ="mysqldump -u root shutdown"
  # Run the command that we just built with our config constants
  #system(command)
  session[:shutdown]='1'
  redirect_to :controller=>"dqms",:action => "logout"

  end
  
  def settings
  end
end
