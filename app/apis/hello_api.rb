class HelloApi < ActionWebService::API::Base
  
  api_method :getData, :expects => [:string,:string,:string,:date,:time,:string,:string,:string,:string,:time,:time,:time,:time,:string,:string,:string,:time,:time,:string,:time,:string,:string,:string,:string,:string],:returns => [:string]
  
end
