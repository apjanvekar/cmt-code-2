class Displayscrollmsg < ActiveRecord::Base
  #------------------------------------ Validation ---------------------------------------------
     validates_length_of :scrollmsg, :within => 5..50
    validates_uniqueness_of :scrollmsg
    validates_presence_of :scrollmsg
    validates_format_of :scrollmsg, :with => /^[a-zA-Z\d ]*$/i,:message =>  "can only contain letters and numbers."  

  #---------------------------------------------------------------------------------------------
end
