class Versionhistory < ActiveRecord::Base
  #-------------------------------- Validation ----------------------------------------------------
  validates_presence_of :javafd
  validates_presence_of :javatd
  validates_presence_of :rubyonrails
  
  validates_format_of :javafd, :with =>/^[.  0-9]+$/x
  validates_format_of :javatd, :with =>/^[.  0-9]+$/x
  validates_format_of :rubyonrails, :with =>/^[.  0-9]+$/x
  #-------------------------------- Validation ----------------------------------------------------
  
end
