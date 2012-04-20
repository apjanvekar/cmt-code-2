#An unpublished work of Sprylogic Technologies Ltd. 
# © Copyright Sprylogic Technologies Ltd. 2008. All rights reserved 

class Counter < ActiveRecord::Base
  has_many :services
  has_and_belongs_to_many :customertypes
  has_and_belongs_to_many :ctypemappings
 
  validates_presence_of :counterno, :on => :create
  validates_uniqueness_of :counterno, :on => :create
   validates_numericality_of :counterno, :message=>"must be a numberic value"
  
  validates_presence_of :counterno, :on => :update
   validates_uniqueness_of :counterno, :on => :update
   #validates_length_of :counterno, :maximum=>3,:on=>:create,:message=>"Please enter up to 3 digit "
 
 def self.counter_no
    Counter.find(:all,:order=>'counterno')
end


end
