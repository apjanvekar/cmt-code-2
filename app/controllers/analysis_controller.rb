class AnalysisController < ApplicationController
 layout 'accounts'
require 'active_record'
require 'csv'
before_filter :login_required
  def counter
    
     params[:startdate ]
  end

  def countersummary
      
  end

  def daywisetokenserved
  end

  def master
  end

  def missingtoken
  end

  def usersummary
  end

  def monthlyusersummary
  end

  def servicesummary
  end

  def benchmark
  end
  def masterreporth
  end
  def masterreporth1
      flash[:notice] = fading_flash_message("data not available for today", 2)  
  end
  
end
