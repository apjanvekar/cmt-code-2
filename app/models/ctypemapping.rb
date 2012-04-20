#An unpublished work of Sprylogic Technologies Ltd. 
# © Copyright Sprylogic Technologies Ltd. 2008. All rights reserved 

class Ctypemapping < ActiveRecord::Base
      has_and_belongs_to_many :counters
      
     def self.counter_customers(counter_no)
        @customer_type_id=Ctypemapping.find_all(["counterno=?",counter_no])
        Customertype.customers_type(@customer_type_id)
    end
end
