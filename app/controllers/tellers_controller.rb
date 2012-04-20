#An unpublished work of Sprylogic Technologies Ltd. 
# ɠCopyright Sprylogic Technologies Ltd. 2008. All rights reserved 

class TellersController < ApplicationController
  layout 'accounts'
  before_filter :login_required
def index
  
end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

def list
  @users=User.find(:all)
  @session['counter']=0
  @session['editcounter']=0
end
  
def list1    
  @counter_pages, @counters = paginate :counters, :per_page => 10
  @session['counter']=0
  @session['editcounter']=0
end

def show
  @counter = Counter.find(params[:id])
end

def new
  @counter = Counter.new   
end



def create
   "#{params[:type1]}"
     @type=Csmapping.find_first(["counterno=?",params[:counter][:counterno]])
     @ctype=Ctypemapping.find_first(["counterno=?",params[:counter][:counterno]])
     @counter=Counter.find_first(["counterno=?",params[:counter][:counterno]])
      if(@counter!=nil)
        render :update do |page|   
                page.alert "Counter No. already exists."
        end
      elsif(@type==nil and params[:type1]==nil and params[:type2]==nil and params[:type3]==nil)
        render :update do |page|
                page.alert "Please select customer type and service."
        end
      elsif(@type==nil)     
        render :update do |page|
               page.alert "Please select atleast one service."
        end
      elsif(params[:type1]==nil and params[:type2]==nil and params[:type3]==nil)     
        render :update do |page|
                page.alert "Please select atleast one customer."
        end
      else        
           @map=Counter.new
           @map.counterno=params[:counter][:counterno]
           #@map.loginstatus=params[:counter][:loginstatus]
           @map.counterstatus=params[:counter][:counterstatus]
           @map.save        
           if (params[:type1]=='1')
               @map=Ctypemapping.new
               @map.counterno=params[:counter][:counterno]
               @map.ctypeid=1
               @map.save
           end
           if (params[:type2]=='2')
               @map=Ctypemapping.new
               @map.counterno=params[:counter][:counterno]
               @map.ctypeid=2
               @map.save
           end
           if (params[:type3]=='3')
               @map=Ctypemapping.new
               @map.counterno=params[:counter][:counterno]
               @map.ctypeid=3
               @map.save
           end    
           @t=Tokendisplay.find_first(["counterno=?",params[:counter][:counterno]])
           if (@t==nil)
               @token=Tokendisplay.new
               @token.counterno=params[:counter][:counterno]
               @token.id=params[:counter][:counterno]
               @token.save
           end
           @counterCtype=Ctypemapping.find_all(["counterno=?",params[:counter][:counterno]])
           @counterCtype.each do |custType|
                 @counterServices=Csmapping.find_all(["counterno=?",params[:counter][:counterno]])
                 @counterServices.each do |counterService|
                           Transact.transaction do
                           @transactCheck=Transact.find(:all,:group=>:tokenno,:conditions=>["ctypeid=? and serviceid=? and tokenstatus=?",custType.ctypeid,counterService.serviceid,'0'],:lock => true)
                           if @transactCheck !=nil or @transactCheck !=[]
                                 @transactCheck.each do |newTransact|
                                  @newTransact=Transact.new
                                  @newTransact.tokenno=newTransact.tokenno
                                  @newTransact.tokenid=newTransact.tokenid
                                  @newTransact.ctypeid=newTransact.ctypeid
                                  @newTransact.transdate=newTransact.transdate
                                  @newTransact.generatedtime=newTransact.generatedtime
                                  @newTransact.serviceid=newTransact.serviceid
                                  @newTransact.counterno=params[:counter][:counterno]
                                  @newTransact.accno=newTransact.accno
                                  @newTransact.login=newTransact.login
                                  @newTransact.calledtime=newTransact.calledtime
                                  @newTransact.servicedtime=newTransact.servicedtime                                  
                                  @newTransact.timetaken=newTransact.timetaken
                                  @newTransact.waittime=newTransact.waittime
                                  @newTransact.stpname=newTransact.stpname
                                  @newTransact.nonstpname=newTransact.nonstpname
                                  @newTransact.tokenstatus=newTransact.tokenstatus
                                  @newTransact.pauseflag=newTransact.pauseflag
                                  @newTransact.pausetime=newTransact.pausetime
                                  @newTransact.releasetime=newTransact.releasetime
                                  @newTransact.bulkcount=newTransact.bulkcount
                                  @newTransact.call1=newTransact.call1
                                  @newTransact.reasons=newTransact.reasons
                                  @newTransact.missingflag=newTransact.missingflag
                                  @newTransact.pullcounter=newTransact.pullcounter
                                  @newTransact.redirecttime=newTransact.redirecttime
                                  @newTransact.score=newTransact.score
                                  @newTransact.exported=newTransact.exported
                                  @newTransact.flag=newTransact.flag
                                  @newTransact.soleid=newTransact.soleid
                                  @newTransact.actcode=newTransact.actcode
                                  @newTransact.serverstatus=newTransact.serverstatus
                                  @newTransact.save
                                 end
                           end 
                          end #end transaction                           
                 end
          end
                       
                 
           flash[:notice] = fading_flash_message("Counter created sucessfully.", 5) 
           render :update do |page|
                  page.redirect_to url_for(:controller=>'tellers', :action=>'list')     
           end    
       end  
              
end


def create1
  
  @totaltypes=0
  @type=0
  @counter = Counter.new(params[:counter])
  @type=Csmapping.find_first(["counterno=?",params[:counter][:counterno]])
  if(@type==nil)
    p "no service mapped"
    #render :action => 'new'
    render :update do |page|
      page.alert "no service mapped"
    end
  else    
    if @counter.save
      flash[:notice] = 'Teller was successfully created.'      
      if (params[:type1]=='1')
        @map=Ctypemapping.new
        @map.counterno=params[:counter][:counterno]
        @map.ctypeid=1
        @map.save
      end
      if (params[:type2]=='2')
        @map=Ctypemapping.new
        @map.counterno=params[:counter][:counterno]
        @map.ctypeid=2
        @map.save
      end
      if (params[:type3]=='3')
        @map=Ctypemapping.new
        @map.counterno=params[:counter][:counterno]
        @map.ctypeid=0
        @map.save
      end    
      if (params[:stype1]=='1')     
        @map=Csmapping.new
        @map.counterno=params[:counter][:counterno]
        @s=Service.find_first(["id=?",1])
        @map.serviceid=@s.serviceid
        @map.save
      end    
      if (params[:stype2]=='2')      
        @map=Csmapping.new
        @map.counterno=params[:counter][:counterno]
        @s=Service.find_first(["id=?",2])
        @map.serviceid=@s.serviceid
        @map.save
      end    
      if (params[:stype3]=='3')     
        @map=Csmapping.new
        @map.counterno=params[:counter][:counterno]
        @s=Service.find_first(["id=?",3])
        @map.serviceid=@s.serviceid
        @map.save
      end
      if (params[:stype4]=='4')     
        @map=Csmapping.new
        @map.counterno=params[:counter][:counterno]
        @s=Service.find_first(["id=?",4])
        @map.serviceid=@s.serviceid
        @map.save
      end
      if (params[:stype5]=='5')     
        @map=Csmapping.new
        @map.counterno=params[:counter][:counterno]
        @s=Service.find_first(["id=?",5])
        @map.serviceid=@s.serviceid
        @map.save
      end
      if (params[:stype6]=='6')     
        @map=Csmapping.new
        @map.counterno=params[:counter][:counterno]
        @s=Service.find_first(["id=?",6])
        @map.serviceid=@s.serviceid
        @map.save
      end
      if (params[:stype7]=='7')
        @map=Csmapping.new
        @map.counterno=params[:counter][:counterno]
        @s=Service.find_first(["id=?",7])
        @map.serviceid=@s.serviceid
        @map.save
      end
      if (params[:stype8]=='8')     
        @map=Csmapping.new
        @map.counterno=params[:counter][:counterno]
        @s=Service.find_first(["id=?",8])
        @map.serviceid=@s.serviceid
        @map.save
      end
      if (params[:stype9]=='9')     
        @map=Csmapping.new
        @map.counterno=params[:counter][:counterno]
        @s=Service.find_first(["id=?",9])
        @map.serviceid=@s.serviceid
        @map.save
      end
      if (params[:stype10]=='10')      
        @map=Csmapping.new
        @map.counterno=params[:counter][:counterno]
        @s=Service.find_first(["id=?",10])
        @map.serviceid=@s.serviceid
        @map.save
      end
      if (params[:stype11]=='11')     
        @map=Csmapping.new
        @map.counterno=params[:counter][:counterno]
        @s=Service.find_first(["id=?",11])
        @map.serviceid=@s.serviceid
        @map.save
      end
      if (params[:stype12]=='12')     
        @map=Csmapping.new
        @map.counterno=params[:counter][:counterno]
        @s=Service.find_first(["id=?",12])
        @map.serviceid=@s.serviceid
        @map.save
      end
      if (params[:stype13]=='13')      
        @map=Csmapping.new
        @map.counterno=params[:counter][:counterno]
        @s=Service.find_first(["id=?",13])
        @map.serviceid=@s.serviceid
        @map.save
      end
      if (params[:stype14]=='14')      
        @map=Csmapping.new
        @map.counterno=params[:counter][:counterno]
        @s=Service.find_first(["id=?",14])
        @map.serviceid=@s.serviceid
        @map.save
      end
      if (params[:stype15]=='15')      
        @map=Csmapping.new
        @map.counterno=params[:counter][:counterno]
        @s=Service.find_first(["id=?",15])
        @map.serviceid=@s.serviceid
        @map.save
      end
      if (params[:stype16]=='16')      
        @map=Csmapping.new
        @map.counterno=params[:counter][:counterno]
        @s=Service.find_first(["id=?",16])
        @map.serviceid=@s.serviceid
        @map.save
      end
      @t=Tokendisplay.find_first(["counterno=?",params[:counter][:counterno]])
      if (@t==nil)
        @token=Tokendisplay.new
        @token.counterno=params[:counter][:counterno]
        @token.id=params[:counter][:counterno]
        @token.save
      end
      render :update do |page|
        page.redirect_to url_for(:controller=>'tellers', :action=>'list')
      end
    else
      render :update do |page|
        page.redirect_to url_for(:controller=>'tellers', :action=>'new')
      end
    end    
  end
end
  
  
  
def edit
  @counter = Counter.find(params[:id])
  @session['editcounter']=@counter.counterno 
end

def update_services
  
  "#{params[:counter][:counterno]}"
   "#{params[:csmapping][:serviceid]}"
  if ((params[:csmapping][:serviceid])=="")
       render :update do |page|
              page.alert "Please select the service."
       end
  else
                @map1=Csmapping.new        
                @map1.counterno=params[:counter][:counterno] 
		        @map1.serviceid=params[:csmapping][:serviceid]
                @map1.pending_service='Y'
    @se1= Csmapping.find_first(["counterno = ? and serviceid=? and cstatus=?",params[:counter][:counterno],params[:csmapping][:serviceid],'1']) 
    if @se1==nil
        @se2= Csmapping.find_first(["counterno = ? and serviceid=? and cstatus=? and pending_service=?",params[:counter][:counterno],params[:csmapping][:serviceid],'0','N']) 
              if @se2==nil
                @se3= Csmapping.find_first(["counterno = ? and serviceid=? and cstatus=? and pending_service=?",params[:counter][:counterno],params[:csmapping][:serviceid],'0','Y']) 
                if @se3==nil
                   @map1.save                
                   render :update do |page|  
                       page.replace_html('rep1', :partial=>'rep1')
                   end
                else
                    Csmapping.update(@se3.id,{:cstatus=>'1'})
                    render :update do |page|  
                       page.replace_html('rep1', :partial=>'rep1')
                    end
                end
              else
                Csmapping.update(@se2.id,{:cstatus=>'1'})
                render :update do |page|  
                    page.replace_html('rep1', :partial=>'rep1')
                end
              end

    else
      render :update do |page| 
        page.alert "This service is already assigned to counter no.""#{params[:counter][:counterno] }"
      end 
    end 
  end
end

 def update
  if(params[:counter][:counterno]=="")
        render :update do |page|
               page.alert "Please enter counter number."
        end     
  else
      @c=params[:counter][:counterno]
      #@type=Csmapping.find_first(["counterno=?",params[:counter][:counterno]])
      @deselected_service=Csmapping.find_first(["counterno=? and cstatus=?",params[:counter][:counterno],'0'])
      @selected_service=Csmapping.find_first(["counterno=? and cstatus=?",params[:counter][:counterno],'1'])
      @ctype=Ctypemapping.find_first(["counterno=?",params[:counter][:counterno]])
      if(@deselected_service!=nil and @selected_service==nil and params[:type1]==nil and params[:type2]==nil and params[:type3]==nil)
                render :update do |page|
                       page.alert "Please select customer type and service."
                end
            elsif(@deselected_service!=nil and @selected_service==nil)
                render :update do |page|
                       page.alert "Please select atleast one service."
                end
            elsif(params[:type1]==nil and params[:type2]==nil and params[:type3]==nil)
                render :update do |page|
                       page.alert "Please select atleast one customer."
                end
      else
            old_cust_type=Ctypemapping.find(:all,:select=>"ctypeid",:conditions=>["counterno=?","#{@c}"])
            @arr_old_cust=Array.new
              old_cust_type.each do |old_cust|
                       @arr_old_cust << old_cust.ctypeid
              end
            @arr_new_cust=Array.new
            @arr_new_cust << params[:type1] << params[:type2] << params[:type3]
            @arr_temp=Array.new
            @transact_count=0
            ######################### Code for removed customer type ######################################
            @arr_temp=@arr_old_cust - @arr_new_cust
            if @arr_temp.any?
               @arr_temp.each do |removed_cust_type|
                   old_services=Csmapping.find(:all,:select=>"serviceid",:conditions=>["counterno=? and pending_service=?",params[:counter][:counterno],'N'])
                   old_services.each do |old_service_id|
                        @transact_count += Transact.count(:all,:conditions=>["ctypeid=? and serviceid=? and tokenstatus not in (?) and counterno=? and (missingflag is null or missingflag<>?)",removed_cust_type,old_service_id.serviceid,[1,5],params[:counter][:counterno],'1000'])
                   end
               end
            end
            if @transact_count > 0
               @transact_count=0
                   render :update do |page|
                             page.alert "Sorry you can not remove old customer type."
                   end
            else
                ######################### Code for exits customer type ######################################
                @arr_temp=@arr_old_cust & @arr_new_cust
                if @arr_temp.any?
                   @arr_temp.each do |not_removed_cust_type|
                      # find demap services
                      demap_services=Csmapping.find(:all,:select=>"serviceid",:conditions=>["counterno=? and cstatus=? and pending_service=?",params[:counter][:counterno],'0','N'])
                      if demap_services != []
                         demap_services.each do |demap_service_id|
                               @transact_count +=Transact.count(:all,:conditions=>["ctypeid=? and serviceid=? and tokenstatus not in (?) and counterno=? and (missingflag is null or missingflag<>?)",not_removed_cust_type,demap_service_id.serviceid,[1,5],params[:counter][:counterno],'1000']) 
                         end
                      end
                   end
                end
                if @transact_count > 0
                   @transact_count=0
                   render :update do |page|
                             page.alert "Sorry you can not remove old service."
                   end
                else
                    # find new map services
                    @arr_temp.each do |not_removed_cust_type|
                    map_services=Csmapping.find(:all,:select=>"serviceid",:conditions=>["counterno=? and cstatus=? and pending_service=?",params[:counter][:counterno],'1','Y'])
                    if map_services != []
                       map_services.each do |map_service_id|
                       Transact.transaction do
                            @transactCheck=Transact.find(:all,:group=>:tokenno,:conditions=>["ctypeid=? and serviceid=? and tokenstatus=?",not_removed_cust_type,map_service_id.serviceid,'0'],:lock => true)
                            if @transactCheck !=nil or @transactCheck !=[]
                               @transactCheck.each do |newTransact|
                                  @newTransact=Transact.new
                                  @newTransact.tokenno=newTransact.tokenno
                                  @newTransact.tokenid=newTransact.tokenid
                                  @newTransact.ctypeid=newTransact.ctypeid
                                  @newTransact.transdate=newTransact.transdate
                                  @newTransact.generatedtime=newTransact.generatedtime
                                  @newTransact.serviceid=newTransact.serviceid
                                  @newTransact.counterno=params[:counter][:counterno]
                                  @newTransact.accno=newTransact.accno
                                  @newTransact.login=newTransact.login
                                  @newTransact.calledtime=newTransact.calledtime
                                  @newTransact.servicedtime=newTransact.servicedtime                                  
                                  @newTransact.timetaken=newTransact.timetaken
                                  @newTransact.waittime=newTransact.waittime
                                  @newTransact.stpname=newTransact.stpname
                                  @newTransact.nonstpname=newTransact.nonstpname
                                  @newTransact.tokenstatus=newTransact.tokenstatus
                                  @newTransact.pauseflag=newTransact.pauseflag
                                  @newTransact.pausetime=newTransact.pausetime
                                  @newTransact.releasetime=newTransact.releasetime
                                  @newTransact.bulkcount=newTransact.bulkcount
                                  @newTransact.call1=newTransact.call1
                                  @newTransact.reasons=newTransact.reasons
                                  @newTransact.missingflag=newTransact.missingflag
                                  @newTransact.pullcounter=newTransact.pullcounter
                                  @newTransact.redirecttime=newTransact.redirecttime
                                  @newTransact.score=newTransact.score
                                  @newTransact.exported=newTransact.exported
                                  @newTransact.flag=newTransact.flag
                                  @newTransact.soleid=newTransact.soleid
                                  @newTransact.actcode=newTransact.actcode
                                  @newTransact.serverstatus=newTransact.serverstatus
                                  @newTransact.save
                                end#do loop end of transact
                            end #transact if end
                        end #end transaction
                        end# map service do loop end
                    end # if end of map services
                    end #do loop end
                    Csmapping.update_all({:pending_service=>'N'},counterno="#{@c}")
                    Csmapping.delete_all(["counterno = ? and cstatus=?",params[:counter][:counterno],'0']) 
                    ############################## Code for new cutomer type ################################
                    @arr_temp= @arr_new_cust - @arr_old_cust
                    if @arr_temp.any?
                       @arr_temp.each do |new_cust_type| 
                           if new_cust_type != nil
                               @all_services=Csmapping.find(:all,:select=>"serviceid",:conditions=>["counterno=? and cstatus=? and pending_service=?",params[:counter][:counterno],'1','N'])
                               if @all_services !=[] or @all_services !=nil
                                  @all_services.each do |service_id| 
                                  Transact.transaction do
                                               @transactCheck=Transact.find(:all,:group=>:tokenno,:conditions=>["ctypeid=? and serviceid=? and tokenstatus=?",new_cust_type,service_id.serviceid,'0'],:lock => true)
                                               if @transactCheck !=nil or @transactCheck !=[]
                                                  @transactCheck.each do |newTransact|
                                                            @newTransact=Transact.new
                                                            @newTransact.tokenno=newTransact.tokenno
                                                            @newTransact.tokenid=newTransact.tokenid
                                                            @newTransact.ctypeid=newTransact.ctypeid
                                                            @newTransact.transdate=newTransact.transdate
                                                            @newTransact.generatedtime=newTransact.generatedtime
                                                            @newTransact.serviceid=newTransact.serviceid
                                                            @newTransact.counterno=params[:counter][:counterno]
                                                            @newTransact.accno=newTransact.accno
                                                            @newTransact.login=newTransact.login
                                                            @newTransact.calledtime=newTransact.calledtime
                                                            @newTransact.servicedtime=newTransact.servicedtime                                  
                                                            @newTransact.timetaken=newTransact.timetaken
                                                            @newTransact.waittime=newTransact.waittime
                                                            @newTransact.stpname=newTransact.stpname
                                                            @newTransact.nonstpname=newTransact.nonstpname
                                                            @newTransact.tokenstatus=newTransact.tokenstatus
                                                            @newTransact.pauseflag=newTransact.pauseflag
                                                            @newTransact.pausetime=newTransact.pausetime
                                                            @newTransact.releasetime=newTransact.releasetime
                                                            @newTransact.bulkcount=newTransact.bulkcount
                                                            @newTransact.call1=newTransact.call1
                                                            @newTransact.reasons=newTransact.reasons
                                                            @newTransact.missingflag=newTransact.missingflag
                                                            @newTransact.pullcounter=newTransact.pullcounter
                                                            @newTransact.redirecttime=newTransact.redirecttime
                                                            @newTransact.score=newTransact.score
                                                            @newTransact.exported=newTransact.exported
                                                            @newTransact.flag=newTransact.flag
                                                            @newTransact.soleid=newTransact.soleid
                                                            @newTransact.actcode=newTransact.actcode
                                                            @newTransact.serverstatus=newTransact.serverstatus
                                                            @newTransact.save
                                                   end#do loop end of transact
                                               end #transact if end
                                   end #end transaction
                                   end #end of loop
                               end # if end
                           end # new cust type check nil if end
                       end # new cust type array end
                    end# new cust type if end
                    @map=Counter.find_first(["counterno=?",params[:counter][:counterno]])
                    if(@map.loginstatus=='Y')
                       @map.counterno=params[:counter][:counterno]
                       #@map.loginstatus=params[:counter][:loginstatus]
                       #@map.counterstatus=params[:counter][:counterstatus]
                       @map.save
                    else
                       @map.counterno=params[:counter][:counterno]
                       @map.loginstatus=params[:counter][:loginstatus]
                       @map.counterstatus=params[:counter][:counterstatus]
                       @map.save 
                    end
                    if (params[:type1]=='1')
                       @map=Ctypemapping.new
                       @map.counterno=params[:counter][:counterno]
                       @map.ctypeid=1
                       @ct= Ctypemapping.find_first(["counterno = ? and ctypeid=1 ",params[:counter][:counterno]]) 
                       if @ct==nil
                          @map.save
                          Csmapping.delete_all(["counterno = ? and cstatus=?",params[:counter][:counterno],'0'])
                       end
                   else
                       @ct= Ctypemapping.delete_all(["counterno = ? and ctypeid=1 ",params[:counter][:counterno]]) 
                   end
                   if (params[:type2]=='2')
                       @map=Ctypemapping.new
                       @map.counterno=params[:counter][:counterno]
                       @map.ctypeid=2
                       @ct1= Ctypemapping.find_first(["counterno = ? and ctypeid=2 ",params[:counter][:counterno]]) 
                       if @ct1==nil
                          @map.save
                          Csmapping.delete_all(["counterno = ? and cstatus=?",params[:counter][:counterno],'0'])
                       end
                   else
                       @ct= Ctypemapping.delete_all(["counterno = ? and ctypeid=2 ",params[:counter][:counterno]]) 
                   end
                   if (params[:type3]=='3')
                       @map=Ctypemapping.new
                       @map.counterno=params[:counter][:counterno]
                       @map.ctypeid=3
                       @ct= Ctypemapping.find_first(["counterno = ? and ctypeid=3 ",params[:counter][:counterno]]) 
                       if @ct==nil
                          @map.save
                          Csmapping.delete_all(["counterno = ? and cstatus=?",params[:counter][:counterno],'0'])
                       end
                   else
                       @ct= Ctypemapping.delete_all(["counterno = ? and ctypeid=3 ",params[:counter][:counterno]]) 
                   end
                   flash[:notice] = fading_flash_message(" Counter updated sucessfully.", 5)
                   render :update do |page|
                         page.redirect_to url_for(:controller=>'tellers', :action=>'list')
                   end
                end# exists cust type else end
            end# remove cust type else end
        end #inner else end
   end#outer else end
end
  
  
def update1
   
  #p "#{@counter.counterno}"
  "#{params[:counter][:counterno]}"
  @c=params[:counter][:counterno]
  if (params[:type1]==nil)
    @ct= Ctypemapping.delete_all(["counterno = ? and ctypeid=1 ",@c]) 
  end
  if (params[:type2]==nil)
    @ct= Ctypemapping.delete_all(["counterno = ? and ctypeid=2 ",@c]) 
  end
  if (params[:type3]==nil)
    @ct= Ctypemapping.delete_all(["counterno = ? and ctypeid=0 ",@c]) 
  end
  @counter =Counter.find(params[:id])
  if @counter.update_attributes(params[:counter])
    flash[:notice] = 'Teller was successfully updated.'
    #if @counter.save
    if (params[:type1]=='1')
      @map=Ctypemapping.new
      @map.counterno=params[:counter][:counterno]
      @map.ctypeid=1
      @ct= Ctypemapping.find_first(["counterno = ? and ctypeid=1 ",params[:counter][:counterno]]) 
      if @ct==nil
        @map.save
      else
      end
    end
    if (params[:type2]=='2')
      @map=Ctypemapping.new
      @map.counterno=params[:counter][:counterno]
      @map.ctypeid=2
      @ct1= Ctypemapping.find_first(["counterno = ? and ctypeid=2 ",params[:counter][:counterno]]) 
      if @ct1==nil
        @map.save
      else
      end
    end
    if (params[:type3]=='0')
      @map=Ctypemapping.new
      @map.counterno=params[:counter][:counterno]
      @map.ctypeid=0
      @ct= Ctypemapping.find_first(["counterno = ? and ctypeid=0 ",params[:counter][:counterno]]) 
      if @ct==nil
        @map.save
      else
      end
    end
  end
  redirect_to :action => 'list'
end

def destroy
  Counter.find(params[:id]).destroy
  redirect_to :action => 'list'
end
  
def back1
  #Csmapping.delete_all(["counterno = ? ",params[:counter][:counterno]]) 
  render :update do |page|
    page.redirect_to url_for(:controller=>'tellers', :action=>'list')
  end
end 

def back
  Csmapping.delete_all(["counterno = ? ",params[:counter][:counterno]]) 
  render :update do |page|
    page.redirect_to url_for(:controller=>'tellers', :action=>'list')
  end
end

 def back_ads
  render :update do |page|
    page.redirect_to url_for(:controller=>'tellers', :action=>'list_ad')
  end
end 
  


def servicesmapped
end
def newscrollmsg
    @dsm = Displayscrollmsg.new
  end

def create_scrollmsg
    @dsm = Displayscrollmsg.new(params[:ad])
    if @dsm.save
      
      redirect_to :action => 'list_scrollmsg'
    else
      render :action => 'scrollmsg'
    end
  end

def edit_scrollmsg
  puts "in edit"
  puts params[:id]
    @dsm = Displayscrollmsg.find(params[:id])
    puts @dsm
  end
  
  
  

  def update_scrollmsg
    @dsm =Displayscrollmsg.find(params[:id])
    if @dsm.update_attributes(params[:dsm])
      flash[:notice] = 'Scroll message was successfully updated.'
      redirect_to :action => 'list_scrollmsg'
    else
      render :action => 'edit_scrollmsg'
    end
  end
  
 def list_scrollmsg
    @ad_pages, @ads = paginate :ads, :per_page => 10
  end 
  
def ad 
    @ad = Ad.new
end

  def create_ad
    @ad = Ad.new(params[:ad])
    if @ad.save
      flash[:notice] = 'Scroll message was successfully created.'
      redirect_to :action => 'list_ad'
    else
      render :action => 'ad'
    end
  end

 def edit_ad

    @ad = Ad.find(params[:id])
  end

  def update_ad
    @ad =Ad.find(params[:id])
    if @ad.update_attributes(params[:ad])
      @findstatus=Ad.find_all(["id<>? and status=?",params[:id],params[:ad][:status]])
      @findstatus.each do |d|
        d.status=0
        d.save    
        puts "data saved"
      end
      flash[:notice] = fading_flash_message("Footer meassge sucessfully updated.", 5)
      redirect_to :action => 'list_ad'
    else
      render :action => 'edit_ad'
    end
  end

  def destroy_ad
    Ad.find(params[:id]).destroy
    flash[:notice] = fading_flash_message("Footer message deleted sucessfully.", 5)
    redirect_to :action => 'list_ad'
  end  
  
 def list_ad
   #@ad = Ad.new
    @ad_pages, @ads = paginate :ads, :per_page => 10
  end

def update_newservices
  
  "#{params[:counter][:counterno]}"
   "#{params[:csmapping][:serviceid]}"
  render :update do |page|
    if ((params[:csmapping][:serviceid])=="")
      page.alert "Please Select the service"
    elsif ((params[:counter][:counterno])=="")
      page.alert "Please enter counterno"
    else
      @map1=Csmapping.new        
      @map1.counterno=params[:counter][:counterno]       
      @map1.serviceid=params[:csmapping][:serviceid]	    
      @se1= Csmapping.find_first(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:csmapping][:serviceid]]) 
      @session['counter'] = (params[:counter][:counterno])
       "counterno=#{@session['counter']}"
      @c=Counter.find_first(["counterno=?",params[:counter][:counterno]])
      if (@c==nil)
        if (@se1==nil)
          @map1.save       
          #p "#{@session['counter']['counterno']}"    
          # p "added"
          #page.replace_html('counterservices', :partial=>'newservices')
          page.replace_html('rep', :partial=>'rep')
          #page.alert "added"    
          #page["service_#{c.id}"].visual_effect :highlight, :duration => 3.5
          #end
        else
          # render :update do |page| 
          page.alert "This service is already assigned to counter no.""#{params[:counter][:counterno] }"
          #end 
        end
      else
        page.alert "Counter already taken."
      end    
    end  
	end 
end



def remove_services
  
  "#{params[:counter][:counterno]}"
  "#{params[:counter][:serviceid]}"
  @map1=Csmapping.new        
  @map1.counterno=params[:counter][:counterno] 
	@map1.serviceid=params[:counter][:serviceid]	    
  @se1= Csmapping.find_first(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:counter][:serviceid]]) 
  render :update do |page|
    if @se1==nil	    
      page.alert "This service is not assigned to counter no.""#{params[:counter][:counterno] }"  
    else
      @t= Csmapping.delete_all(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:counter][:serviceid]]) 
      @session['counter'] = (params[:counter][:counterno])
      #page.replace_html('counterservices', :partial=>'newservices')
      page.replace_html('rep', :partial=>'rep')
    end 
  end
end



def all_services
  @e=params[:counter][:counterno]
  @session['counter'] = (params[:counter][:counterno])
  if @e==""
    render :update do |page|
      page.alert "Please enter the counter number."
    end
  else
    @map1=Csmapping.new    
		#@map1.serviceid=params[:csmapping][:serviceid]	    
    @all=Service.find(:all,:conditions =>["servicestatus=?",'1'])
    @all.each do |d|      
      @map1=Csmapping.new        
      @map1.counterno=params[:counter][:counterno]
      @map1.serviceid=d.serviceid
      @se1= Csmapping.find_first(["counterno = ? and serviceid=? ",@map1.counterno,@map1.serviceid]) 
      if @se1==nil
        @map1.save  
      end      
    end
  end
  render :update do |page|
    #page.replace_html('counterservices', :partial=>'newservices')
    page.replace_html('rep', :partial=>'rep')
  end
  #@t= Csmapping.delete_all(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:csmapping][:serviceid]]) 
	#end 
end

def remove_all
  #@re= Csmapping.find_all(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:csmapping][:serviceid]]) 
  #@re.each do |d|
   
  Csmapping.delete_all(["counterno = ? ",params[:counter][:counterno]]) 
  @session['counter'] = (params[:counter][:counterno])    
  render :update do |page|
    #page.replace_html('counterservices', :partial=>'newservices')
    page.replace_html('rep', :partial=>'rep')
  end
end

def remove_eservices1
  #p"#{params[:counter][:counterno]}"
  @session['editcounter'] = (params[:counter][:counterno])
  @map1=Csmapping.new        
  @map1.counterno=params[:counter][:counterno] 
  @map1.serviceid=params[:csmapping][:serviceid]	    
  @se1= Csmapping.find_first(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:csmapping][:serviceid]]) 
  if @se1==nil	      
    render :update do |page|
      page.alert "This service is not assigned to counter no.""#{params[:counter][:counterno] }"  
    end
  else
    @t= Csmapping.delete_all(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:csmapping][:serviceid]]) 
    render :update do |page|
      #page.replace_html('counterservices', :partial=>'newservices')
      page.replace_html('rep1', :partial=>'rep1')
    end
	end 
end

def remove_eservices
  
  "#{params[:counter][:counterno]}"
  "#{params[:counter][:serviceid]}"
  @map1=Csmapping.new        
  @map1.counterno=params[:counter][:counterno]       
  @map1.serviceid=params[:counter][:serviceid]	    
  @se1= Csmapping.find_first(["counterno = ? and serviceid=? ",params[:counter][:counterno],params[:counter][:serviceid]]) 
  @session['editcounter'] = (params[:counter][:counterno]) 
   @session['editcounter']
  render :update do |page|
    if @se1==nil   
      page.alert "This service is not assigned to counter no.""#{params[:counter][:counterno] }"  
    else
      Csmapping.update(@se1.id,{:cstatus=>'0'})
      
      #page.replace_html('counterservices', :partial=>'counterservices')
      page.replace_html('rep1', :partial=>'rep1')
    end 
  end
end


def all_eservices11
  @e=params[:counter][:counterno]
 
  if @e==""
    
    render :update do |page|
  
  page.alert "Please enter the counter number."
  end
  else
  @map1=Csmapping.new    
		#@map1.serviceid=params[:csmapping][:serviceid]	    
    @all=Service.find(:all)
    @all.each do |d|
      
      @map1=Csmapping.new        
      @map1.counterno=params[:counter][:counterno]
      @map1.serviceid=d.serviceid
      @map1.save    
      end
  end
 render :update do |page|
    page.replace_html('rep1', :partial=>'rep1')
   end
end

def all_eservices
  @e=params[:counter][:counterno]
  @session['editcounter'] = (params[:counter][:counterno])
  if @e==""
    render :update do |page|
      page.alert "Please enter the counter number."
    end
  else
    #@map1=Csmapping.new    
    @all=Service.find(:all,:conditions =>["servicestatus=?",'1'])
    @all.each do |d|      
      @map1=Csmapping.new        
      @map1.counterno=params[:counter][:counterno]
      @map1.serviceid=d.serviceid
      @map1.pending_service='Y'
      @se1= Csmapping.find_first(["counterno = ? and serviceid=?",@map1.counterno,@map1.serviceid]) 
      if @se1==nil
         @map1.save
      else
        Csmapping.update_all({:cstatus=>'1'},id="#{@se1.id}")           
      end  
    end
  end
     render :update do |page|
          page.replace_html('rep1', :partial=>'rep1')
     end  
end

def remove_eall
     @session['editcounter'] = (params[:counter][:counterno])
     @session=@session['editcounter']
     Csmapping.update_all({:cstatus=>'0'},{:counterno=>"#{@session}"})
     #Csmapping.update(@se1.id,{:cstatus=>'0'})
     render :update do |page|
            page.replace_html('rep1', :partial=>'rep1')
     end
end
########### For Deletion of the counters########################
def deletecounters
    @counter = Counter.find(params[:id])
    @a=@counter.counterno
    @loginstatus=@counter.loginstatus
    @trans_count=Transact.count(:all,:conditions=>["tokenstatus<>? and counterno=?",'1',"#{@a}"])
    if @loginstatus=='N' and @trans_count==0
        Csmapping.delete_all(["counterno = ?","#{@a}"])
        Ctypemapping.delete_all(["counterno = ?","#{@a}"])
        Counter.delete_all(["counterno = ?","#{@a}"])
        flash[:notice] = fading_flash_message("Counter deleted successfully.", 5) 
        render :action => 'list'
    else
        flash[:notice] = fading_flash_message("Sorry,you can not delete this counter.", 5) 
        render :action => 'list'
    end    
end

def newback
    @session1 = @session['editcounter']
    Csmapping.delete_all(["counterno = ? and pending_service=?",@session1,'Y']) 
    Csmapping.update_all({:cstatus=>'1'},counterno="#{@session1}")
    render :action => 'list'
end

  
end
