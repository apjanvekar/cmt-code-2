class Hello1Api < ActionWebService::API::Base
  api_method :login, :expects => [{:login=>:string}, 
{:password=>:string},{:soleid=>:string}],:returns => [:string]

  api_method :logout, :expects => [{:login=>:string}], :returns => [:string]
end
