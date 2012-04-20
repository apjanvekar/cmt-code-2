#An unpublished work of Sprylogic Technologies Ltd. 
# © Copyright Sprylogic Technologies Ltd. 2008. All rights reserved 

class Service < ActiveRecord::Base

  #------------------------ Relationship -------------------------------------------------
    belongs_to :users
    belongs_to :counters
    belongs_to :stps
  #--------------------------------------------------------------------------------------- 

  #------------------------------ Validation --------------------------------------------- 
    validates_uniqueness_of :serviceid
    #validates_uniqueness_of :servicename
    #validates_uniqueness_of :buttonno,:on=>:update 
  
    validates_presence_of :serviceid
    #validates_presence_of :servicename
    validates_presence_of :buttonno, :on=>:update
    #validates_time :endtime, :after => [:starttime]
   #--------------------------------------------------------------------------------------  
   def self.service_name(services_id)
       services_name=Array.new
       services_id.each do |service_id|
            services_name << Service.find(:first, :conditions=>["serviceid = ? ",service_id.serviceid])
        end
        return services_name
   end
end
