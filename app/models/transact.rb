#An unpublished work of Sprylogic Technologies Ltd. 
# © Copyright Sprylogic Technologies Ltd. 2008. All rights reserved 

class Transact < ActiveRecord::Base
   acts_as_reportable
#validates_length_of :accno, :maximum => 12, :on => :create
#validates_numericality_of :accno, :on => :create

  #--------------------------------- Default value set ---------------------------------
  
  before_create :default_values
  def default_values
    if  self.calledtime = 'null'
       self.calledtime= '00:00:00' unless self.calledtime
    end   
  end

end
