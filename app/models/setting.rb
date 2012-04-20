class Setting < ActiveRecord::Base
  #--------------------- Validation for Blank ------------------------------------------------
    validates_presence_of :missingcount,
                          :on => :update,
                          :message => "^Missing count should not be blank."
    validates_presence_of :returntime,
                          :on => :update,
                          :message => "^Screen time should not be blank."
    validates_presence_of :branchname,
                          :on => :update,
                          :message => "^Branch name should not be blank."
    validates_presence_of :soleid,
                          :on => :update,
                          :message => "^Branch soleid should not be blank."
    #--------------------- Validation for format ------------------------------------------------
   
    validates_format_of :branchname, 
                         :with => /^[a-zA-Z\d ]*$/i,
                         :message =>  "^Branch name should not contain characters or special symbols." 
                         
     validates_numericality_of :missingcount,
                               :on => :update,
                               :message => "^Missing count should not contain characters or special symbols."
                               
     validates_numericality_of :returntime, 
                               :on => :update,
                               :message => "^Screen time should not contain characters or special symbols."
     validates_numericality_of :accountscreentime, 
                               :on => :update,
                               :message => "^Screen timeout should not contain characters or special symbols."
     
     validates_inclusion_of :missingcount, 
                            :in => 0..99,
                            :message => "^Missing count should be in between 0 and 99."
     validates_inclusion_of :returntime, 
                            :in => 0..60,
                            :message =>"^Screen time should be in between 0 and 60."
     validates_inclusion_of :accountscreentime, 
                            :in => 0..60, 
                            :message =>"^Screen timeout should be in between 0 and 60."                            
     
      
      
  #---------------------------------------------------------------------------------------------
end
