#An unpublished work of Sprylogic Technologies Ltd. 
# © Copyright Sprylogic Technologies Ltd. 2008. All rights reserved 

class Customertype < ActiveRecord::Base
  
  has_and_belongs_to_many :counters
  def self.customers_type(customer_type_id)
       customer_types=Array.new
       customer_type_id.each do |ctype_id|
            customer_types <<  Customertype.find(:first, :conditions=>["ctypeid = ? ",ctype_id.ctypeid]) 
        end
        return customer_types
   end
end
