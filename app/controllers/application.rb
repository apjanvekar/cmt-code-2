#An unpublished work of Sprylogic Technologies Ltd. 
# © Copyright Sprylogic Technologies Ltd. 2008. All rights reserved 

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
#require 'login_system'
require 'custom_error_message'
class ApplicationController < ActionController::Base

  # Pick a unique cookie name to distinguish our session data from others'
 #layout 'standard'
  include LoginSystem
  model :user

#session :session_key => '_DQMS_session_id'
before_filter :timvar
  def timvar
  
  session[:b]
  session[:gvar]
end

#################################################################################
##                           Session Expiration                                ##
##                                   Start                                     ##
#################################################################################
MAX_SESSION_TIME = 900
before_filter :prepare_session

def prepare_session

   if !session[:expiry_time].nil? and session[:expiry_time] < Time.now
      # Session has expired. Clear the current session.
      #cookies.delete :user_id
	redirect_to :controller =>'dqms',:action =>'logout'
      #reset_session
   end

   # Assign a new expiry time, whether the session has expired or not.
   session[:expiry_time] = MAX_SESSION_TIME.seconds.from_now
   return true
end
#################################################################################
##                           Session Expiration                                ##
##                                   End                                       ##
#################################################################################

def fading_flash_message(text, seconds=3)
  text +
    <<-EOJS
      <script type='text/javascript'>
        Event.observe(window, 'load',function() { 
          setTimeout(function() {
            message_id = $('notice') ? 'notice' : 'warning';
            new Effect.Fade(message_id);
          }, #{seconds*1000});
        }, false);
      </script>
    EOJS
end

private 
    def login_required    
        if !session['user']
            
          redirect_to "/dqms/index"
          return false
        end    
      end

end
