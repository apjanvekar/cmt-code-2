#An unpublished work of Sprylogic Technologies Ltd. 
# © Copyright Sprylogic Technologies Ltd. 2008. All rights reserved 

class Ad < ActiveRecord::Base
  #------------------------------------ Validation ---------------------------------------------
    validates_length_of :adtext, :within => 5..50
    validates_uniqueness_of :adtext
    validates_presence_of :adtext
    #validates_format_of :adtext, :with => /^\w*$/ 
validates_format_of :adtext, :with => /^[a-zA-Z\d ]*$/i,:message =>  "can only contain letters and numbers."  
  #---------------------------------------------------------------------------------------------
end
