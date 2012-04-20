#An unpublished work of Sprylogic Technologies Ltd. 
# © Copyright Sprylogic Technologies Ltd. 2008. All rights reserved 

class Csmapping < ActiveRecord::Base
    has_and_belongs_to_many :counters
    def self.counter_services(counter_no)
        @services_id=Csmapping.find_all(["counterno=? and cstatus=? and pending_service=?",counter_no,1,'N'])
        Service.service_name(@services_id)
    end
end
