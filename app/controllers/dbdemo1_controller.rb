class Dbdemo1Controller < ApplicationController 
  layout 'accounts'
  before_filter :login_required
    def selection
        
        #redirect_to :action => "selection"
    end
  
    def Branch_analysis_chart
        
         "modification ..........."
         params[:startdate]
         params[:enddate]       
        @arr1=[]
        @arr2=[]
        @service_name=[]
        if params[:startdate].to_date == Date.today and params[:enddate].to_date == Date.today 
            puts "You r in if.........................."
            @service_id=Transact.find(:all, 
		         					  :select => "distinct serviceid" , 
                                      :conditions => "transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'")
              
               @service_id.inspect
              
		           
                if @service_id.to_s == ''
                    flash[:notice] = "No Data Found"
                    redirect_to :action => "selection"
                else
                    
                @service_id.each do |ser_id| 
          			@serv_name = Service.find(:all,
                                              :conditions => " serviceid = '#{ser_id.serviceid}'").each do |a|
										            @servicename= a.servicename.to_s 	
                                              end
                    @served= Transact.count(:tokenno , 
					         				:conditions => "serviceid='#{ser_id.serviceid}'and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and tokenstatus=1" )
					@pending= Transact.count(:tokenno , 
                                             :conditions => "serviceid='#{ser_id.serviceid}'and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and tokenstatus=0" )
												
                        @arr1=@arr1<<@served         
						@arr2=@arr2<<@pending
                        @service_name=@service_name<<@servicename
                                                 
                        len=@service_name.length
                        @dev=[]

                            for i in 0..len-1 do
                                if i==len-1
                                    @dev<<'\''+@service_name[i].to_s+'\''
                                else
                                    @dev<<'\''+@service_name[i].to_s+'\''
                                    @dev<<','
                                end
                             end                                                
							end 
                        end	
                    
        else
         
	       @service_id= Transact.find_by_sql("select distinct(serviceid) from transactmaster where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'")
                if @service_id.to_s == ''
                    flash[:notice] = "No Data Found"
                    redirect_to :action => "selection"
                else
                    @service_id.each do |ser_id|
           			@serv_name = Service.find(:all,
		        						      :conditions => " serviceid = '#{ser_id.serviceid}'").each do |a|
												 @servicename= a.servicename.to_s 	
                                      		end
									
					@ser= Transact.find_by_sql("select count(tokenno) as count1 from transactmaster where serviceid='#{ser_id.serviceid}'and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and tokenstatus=1")
                    @served= @ser[0].count1
                                           																		  
					@pen= Transact.find_by_sql("select count(tokenno) as count2 from transactmaster where serviceid='#{ser_id.serviceid}'and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and tokenstatus=0")
                    @pending= @pen[0].count2
                    
                        @arr1=@arr1<<@served         
						@arr2=@arr2<<@pending
                        @service_name=@service_name<<@servicename
                                                 
                        len=@service_name.length
                        @dev=[]

                        for i in 0..len-1 do
                            if i==len-1
                                @dev<<'\''+@service_name[i].to_s+'\''
                            else
                                @dev<<'\''+@service_name[i].to_s+'\''
                                @dev<<','
                            end
                          end                                                
						end
 
                 end            
                end
    
 
        end
    def Customerwise_employee_score
        ")()*()(&)(*)(*()" 
        "modification ..........."
        
         params[:customertype][:ctype_id]
         params[:startdate]
         params[:enddate]       
       @arr1=[]
       @user_name=[]
       
       if params[:startdate].to_date == Date.today and params[:enddate].to_date == Date.today 
          
         @user_id=Transact.find(:all, 
									:select => "distinct login" , 
									:conditions => "transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and ctypeid='#{params[:customertype][:ctype_id]}'")
		           
                  if @user_id.to_s == ''
                    flash[:notice] = "No Data Found"
                    redirect_to :action => "selection2"
                  else                
                    @user_id.each do |ser_id| 
                   
                        
          			        @username= ser_id.login.to_s         
                
                			 @served= Transact.count(:tokenno , 
                                                    :conditions => "login='#{ser_id.login}'and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and ctypeid='#{params[:customertype][:ctype_id]}' and tokenstatus=1" )
									   if @username != ''				
                                                 @arr1=@arr1<<@served
                                                 @user_name=@user_name<<@username                                            
											end    
                                              len=@user_name.length
                                            @dev=[]

                                            for i in 0..len-1 do
                                                if i==len-1
                                                    @dev<<'\''+@user_name[i].to_s+'\''
                                                    puts "&&&&&&&&&&&&&"
                                                    p @dev
                                                else
                                                    @dev<<'\''+@user_name[i].to_s+'\''
                                                    @dev<<','
                                                end
                                            end                                                
                                                                                     
                                             
                                          
                                      end	
                                  end   
                                
         else
          
         @user_id=Transact.find_by_sql("select distinct(login) from transactmaster where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'and ctypeid='#{params[:customertype][:ctype_id]}'")
        
		           
                  if @user_id.to_s == ''
                    flash[:notice] = "No Data Found"
                    redirect_to :action => "selection2"
                  else                
                    @user_id.each do |ser_id| 
                   
                        
          			        @username= ser_id.login.to_s         
                
                			@ser=Transact.find_by_sql("select count(tokenno) as count1 from transactmaster where login='#{ser_id.login}'and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and ctypeid='#{params[:customertype][:ctype_id]}' and tokenstatus=1")
                                   @served= @ser[0].count1
											
                                         if @username != ''

                                                 @arr1=@arr1<<@served
                                            
                                                @user_name=@user_name<<@username  
                                              end      
											
                                             len=@user_name.length
                                            @dev=[]

                                            for i in 0..len-1 do
                                                if i==len-1
                                                    @dev<<'\''+@user_name[i].to_s+'\''
                                                else
                                                    @dev<<'\''+@user_name[i].to_s+'\''
                                                    @dev<<','
                                                end
                                              end                                                
                                         end                                            
                                                 
                                          
                                     
                        end                                                
                    end
        
                 
        
    end
      
    
   
   def Hourly_footfall_trends
        
       
        @date=Date.today
         @date   
        
        @arr1=['10','11','12','13','14','15','16','17']
        @ctypeid1=[]
        @ctypeid2=[]
        @ctypeid3=[]
        
        #if  params[:enddate].to_date == Date.today 
            @ctype_id=Transact.find(:all, 
		         					  :select => "distinct ctypeid" , 
                                      :conditions => "transdate ='#{@date}'")
                            
                 "--------------------------------------1st step"
             
                if @ctype_id.to_s == ''
                    flash[:notice] = "No Data Found"
                    redirect_to :action => "nodata4hourly"
                
                else
                    
                  
                @ctype_id.each do |ser_id| 
          			
                     len=@arr1.length
                    for i in 0..len-1 do 
                         
                                                                 
                                              
                             @ser=Transact.find_by_sql("select count(tokenno) as count 
                                                          from transacts 
	                                                      where transdate='#{@date}' 
                                                          and tokenstatus=1 
                                                          and ctypeid= #{ser_id.ctypeid}
                                                          and hour(servicedtime)=#{@arr1[i]}")                    
                                   p ">>---------------------->#{@served= @ser[0].count} <-------------------<<"     
                               ser_id.ctypeid
                            if  ser_id.ctypeid.to_i == 1        
                                @ctypeid1 =@ctypeid1<<@served                            
                            end
                          
                             if  ser_id.ctypeid.to_i == 2        
                               @ctypeid2 =@ctypeid2<<@served                            
                            end
                          
                             if  ser_id.ctypeid.to_i == 3        
                               @ctypeid3 =@ctypeid3<<@served                            
                            end
                       
                       end                                        
					end 
                end	
                    
        #end
        
    end
   
    
     def Footfall_trends_services
         "Footfall_trends_services....................................."
         params[:startdate]
         params[:enddate]       
        @arr1=[]
        @arr2=[]
        @service_name=[]
        if params[:startdate].to_date == Date.today and params[:enddate].to_date == Date.today 
            @service_id=Transact.find(:all, 
		         					  :select => "distinct serviceid" , 
                                      :conditions => "transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'")
		           
                if @service_id.to_s == ''
                    flash[:notice] = "No Data Found"
                    redirect_to :action => "selection4"
                else
                    
                @service_id.each do |ser_id| 
          			@serv_name = Service.find(:all,
                                              :conditions => " serviceid = '#{ser_id.serviceid}'").each do |a|
										            @servicename= a.servicename.to_s 	
                                              end
                    @served= Transact.count(:tokenno , 
					         				:conditions => "serviceid='#{ser_id.serviceid}'and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and tokenstatus=1" )
												
                        @arr1=@arr1<<@served         
					    @service_name=@service_name<<@servicename
                                                 
                        len=@service_name.length
                        @dev=[]

                            for i in 0..len-1 do
                                if i==len-1
                                    @dev<<'\''+@service_name[i].to_s+'\''
                                else
                                    @dev<<'\''+@service_name[i].to_s+'\''
                                    @dev<<','
                                end
                             end                                                
							end 
                        end	
                    
        else
 "in else"
	       @service_id= Transact.find_by_sql("select distinct(serviceid) from transactmaster where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'")
                if @service_id.to_s == ''
                    flash[:notice] = "No Data Found"
                    redirect_to :action => "selection4"
                else
                    @service_id.each do |ser_id|
           			@serv_name = Service.find(:all,
		        						      :conditions => " serviceid = '#{ser_id.serviceid}'").each do |a|
												 @servicename= a.servicename.to_s 	
                                      		end
									
					@ser= Transact.find_by_sql("select count(tokenno) as count1 from transactmaster where serviceid='#{ser_id.serviceid}'and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and tokenstatus=1")
                    @served= @ser[0].count1
                                           																		  
					
                        @arr1=@arr1<<@served         
						@service_name=@service_name<<@servicename
                                                 
                        len=@service_name.length
                        @dev=[]

                        for i in 0..len-1 do
                            if i==len-1
                                @dev<<'\''+@service_name[i].to_s+'\''
                            else
                                @dev<<'\''+@service_name[i].to_s+'\''
                                @dev<<','
                            end
                          end                                                
						end
 
                 end            
                end
    
 
        end
   
       def Employee_score
         "Employee_score........................"
         params[:startdate]
         params[:enddate]       
       @arr1=[]
       @arr2=[]
       @user_name=[]
       
       if params[:startdate].to_date == Date.today and params[:enddate].to_date == Date.today 
           "in if"
         @user_id=Transact.find(:all, 
									:select => "distinct login" , 
									:conditions => "transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'")
		           
                  if @user_id.to_s == ''
                    flash[:notice] = "No Data Found"
                    redirect_to :action => "selection5"
                  else                
                    @user_id.each do |ser_id| 
                   
                        
          			        @username= ser_id.login.to_s         
                
                			@maxscore= Transact.maximum(:score , 
                                                    :conditions => "login='#{ser_id.login}'and transdate>='#{params[:startdate]}'
                                                    and transdate<='#{params[:enddate]}' and tokenstatus=1" )
                            @avgscore= Transact.average(:score , 
                                                    :conditions => "login='#{ser_id.login}'and transdate>='#{params[:startdate]}'
                                                    and transdate<='#{params[:enddate]}' and tokenstatus=1" )                        
											if @username != ''	
                                            
                                                 @arr1=@arr1<<@maxscore
                                                @arr2=@arr2<<@avgscore
                                                @user_name=@user_name<<@username                                            
											end
                                             len=@user_name.length
                                            @dev=[]

                                            for i in 0..len-1 do
                                                if i==len-1
                                                    @dev<<'\''+@user_name[i].to_s+'\''
                                                else
                                                    @dev<<'\''+@user_name[i].to_s+'\''
                                                    @dev<<','
                                                end
                                              end                                                
                                                                                     
                                                 
                                          
                                      end	
                                  end   
                                
         else
           "in else"
         @user_id=Transact.find_by_sql("select distinct(login) from transactmaster where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'")
          
          
                
                    
		           
                  if @user_id.to_s == ''
                    flash[:notice] = "No Data Found"
                    redirect_to :action => "selection5"
                  else                
                    @user_id.each do |ser_id| 
                   
                        
          			        @username= ser_id.login.to_s    

                       
                             if @username != ''       
                			 @maxs=Transact.find_by_sql("select max(score) as count1 from transactmaster where login='#{ser_id.login}'and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and tokenstatus=1")
                                   @maxscore= @maxs[0].count1
                                   
                             @avgs=Transact.find_by_sql("select avg(score) as count2 from transactmaster where login='#{ser_id.login}'and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and tokenstatus=1")
                                   @avgscore= @avgs[0].count2     
											if @username != ''					
                                                 @arr1=@arr1<<@maxscore
                                                 @arr2=@arr2<<@avgscore
                                                 @user_name=@user_name<<@username                                            
											end
                                             len=@user_name.length
                                            @dev=[]

                                            for i in 0..len-1 do
                                                if i==len-1
                                                    @dev<<'\''+@user_name[i].to_s+'\''
                                                else
                                                    @dev<<'\''+@user_name[i].to_s+'\''
                                                    @dev<<','
                                                end
                                              end                                                
                                                                                     
                                                 
                                             end
                                             
                             end         
                        end                                                
                   
        end
                 
        
    end
      
    
    
      def Tellerwise_breakup_of_tokens_served
       
        puts "modification ..........."
        p "------------------------------------------Customerwise employee scoe ----------------------------------------"
        puts params[:customertype][:ctype_id]
        puts params[:startdate]
        puts params[:enddate]       
       @arr1=[]
       @user_name=[]
       
       if params[:startdate].to_date == Date.today and params[:enddate].to_date == Date.today 
          p "in if"
         @user_id=Transact.find(:all, 
									:select => "distinct login" , 
									:conditions => "transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and ctypeid='#{params[:customertype][:ctype_id]}'" , 
                                    :order =>  "login" )
		           
                  if @user_id.to_s == ''
                    flash[:notice] = "No Data Found"
                    redirect_to :action => "selection6"
                  else                
                    @user_id.each do |ser_id| 
                   
                        
          			        @username= ser_id.login.to_s         
                
                			@served= Transact.count(:tokenno , 
                                                    :conditions => "login='#{ser_id.login}'and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and ctypeid='#{params[:customertype][:ctype_id]}' and tokenstatus=1" )
									      if @username != ''				
                                                 @arr1=@arr1<<@served
                                                 @user_name=@user_name<<@username                                            
                                            

                                             
                                              
                                              
                                            p "------------------->#{len=@user_name.length}<--------------"
                                            
                                            @dev=[]

                                            for i in 0..len-1 do
                                                if i==len-1
                                                    @dev<<'\''+@user_name[i].to_s+'\''
                                                else
                                                    @dev<<'\''+@user_name[i].to_s+'\''
                                                    @dev<<','
                                                end
                                              end                                                
                                            
                                            p "------------------------->> #{@user_name.join(',').to_s}<<-----------------------------"   
                                               @fin=[]
                                              
                                                
                                           end   
                                      end	
                                  end   
                                
         else
          p "in else"
         @user_id=Transact.find_by_sql("select distinct(login) 
                                                from transactmaster 
                                                where transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}'
                                                and ctypeid='#{params[:customertype][:ctype_id]}'
                                                order by login
                                                ")
        
		           
                  if @user_id.to_s == ''
                    flash[:notice] = "No Data Found"
                    redirect_to :action => "selection6"
                  else                
                    @user_id.each do |ser_id| 
                   
                        
          			        @username= ser_id.login.to_s         
                
                			 @ser=Transact.find_by_sql("select count(tokenno) as count1 from transactmaster where login='#{ser_id.login}'and transdate>='#{params[:startdate]}' and transdate<='#{params[:enddate]}' and ctypeid='#{params[:customertype][:ctype_id]}' and tokenstatus=1")
                                   @served= @ser[0].count1
											
                                         if @username != ''
                                            
                                                 @arr1=@arr1<<@served
                                                 @user_name=@user_name<<@username  
                                              
											
                                             len=@user_name.length
                                            @dev=[]

                                            for i in 0..len-1 do
                                                if i==len-1
                                                    @dev<<'\''+@user_name[i].to_s+'\''
                                                else
                                                    @dev<<'\''+@user_name[i].to_s+'\''
                                                    @dev<<','
                                                end
                                              
                                             end   
                                         end 
                                         p "------------------------->> #{@dev}<<-----------------------------"                                           
                                             if @dev.to_s != ''
                                                p @dlen=@user_name.length
                                                p @alen=@arr1.length
                                                 @c=[]
                                                 @d=[]
                                                    for i in 0..@dlen-1 do
                                                        for j in 0..@alen-1 do
                                                            if i==j
                                                                @c=[]
                                                                @c=@c<<'\''+@user_name[i].to_s+'\''.to_s<<@arr1[j].to_i
                                                                @d=@d<<@c
                                                            end
                                                            
                                                       end
                                                     
                                                    end
                                                    
                                             end 
                                    end                                              
                                 p @main=@d
                                     
                        end                                                
                    end
        
                 
        
    end
      
    
  
   
    
      def selection_old()
      #  @ctrl_file = File.expand_path(__FILE__)

        #begin
            # Detect if the database bas been set up
          #  dummy = Revenue.find(:first)
        #rescue Exception
            # Cannot access data => return set up message
          #  @title = "Database Integration Demo (1)"
           # puts @errmsg = $!
            
          #  render :template => "templates/dbsetup"
        #end
      end
      
      def selection1()
      end
      
      def getchartmodi123
        
      
      end
      
      
      
      def getchartmodi1
      puts "modification1 ..........."
            #puts params["user"]
            puts params[:date1]
            puts params[:date2]
            
            
            
       # selectuser = params["user"]
        
       # selectedYear = (params["year"] || 2001).to_i

        #
        # Query database for the selected year and read results into arrays
        #

        #records = Revenue.find(:all, :conditions => "
          #                                  and [login ='#{selectuser}" )

     # SQL statement to get the revenue for the 12 years from 1990 to 2001
        #sQL =
          #  "Select Sum(Software + Hardware + Services) As annualRevenue, " \
           # "Year(TimeStamp) As theYear From revenues Where Year(TimeStamp) >= 1990 " \
           # "And Year(TimeStamp) <= 2001 Group By Year(TimeStamp) Order By " \
           # "Year(TimeStamp)"

      sQL = "select count(distinct(tokenno)) as counter,transdate from transactmaster
            where  tokenstatus='1' and transdate<='#{params[:date2]}'and transdate>='#{params[:date1]}'
            group by transdate"
             
        
        #sQL = "select count(*) as counter,transdate from transacts
          #  where tokenstatus='2' and  transdate<='2010-08-01'and transdate>='2010-01-01'
           # group by transdate "
        #
        # Connect to database and read the query result into arrays
        #

        records = Transact.find_by_sql(sQL)


    
        #records = Transact.find(:all, :select => "DISTINCT tokenno", :conditions => " transdate<='#{params[:date2]}' and transdate>='#{params[:date1]}' 
          #                                  and tokenstatus='2' " )
                                            
        
         #Product.find(:all, :select => "DISTINCT product.construction.frame")
        
        #records = Transact.find(:all, :conditions => " transdate<='#{params[:date2]}' and transdate>='#{params[:date1]}' 
          #                                  and login='#{selectuser}' " )
        
        #records = Revenue.find(:all, :conditions => " TimeStamp<='#{params[:date2]}' and TimeStamp>='#{params[:date1]}' 
          #                                  and login='#{selectuser}' " )
                                            
    
        #records = Revenue.find(:all, :conditions => ["Year(TimeStamp) = ?", selectedYear],
        #    :order => "TimeStamp")

     #   software = []
      #  hardware = []
      #  services = []
        
        #records.each do |r|
          #  software.push(r.Software)
           # hardware.push(r.Hardware)
           # services.push(r.Services)
        #end


                software = []
        hardware = []
        services = []
        
        records.each do |r|
           puts  software.push(r.counter.to_i)
           hardware.push(r.transdate)
          #  hardware.push(r.Hardware)
           # services.push(r.Services)
        end

      #for i in 0..hardware.length 
    #puts hardware [i]
    #end
    
        
        #
        # Now we have read data into arrays, we can draw the chart using ChartDirector
        #

        # Create a XYChart object of size 600 x 300 pixels, with a light grey (eeeeee)
        # background, black border, 1 pixel 3D border effect and rounded corners.
        c = ChartDirector::XYChart.new(700, 400, 0xeeeeee, 0x000000, 1)
        #c.setRoundedFrame()

        # Set the plotarea at (60, 60) and of size 520 x 200 pixels. Set background color
        # to white (ffffff) and border and grid colors to grey (cccccc)
        c.setPlotArea(60, 100, 520, 200, 0xffffff, -1, 0xcccccc, 0xccccccc)

        # Add a title to the chart using 15pts Times Bold Italic font, with a light blue
        # (ccccff) background and with glass lighting effects.
        c.addTitle(sprintf("Footfall Summary Graph "), "timesbi.ttf", 15
            ).setBackground(0xccccff, 0x000000, ChartDirector::glassEffect())

        # Add a legend box at (70, 32) (top of the plotarea) with 9pts Arial Bold font
        c.addLegend(70, 32, false, "arialbd.ttf", 9).setBackground(
            ChartDirector::Transparent)

        # Add a stacked bar chart layer using the supplied data
        layer = c.addBarLayer2(ChartDirector::Stack)
        layer.addDataSet(software, 0xff0000, "Customer / Day")
        #layer.addDataSet(hardware, 0x00ff00, "Hardware")
        #layer.addDataSet(services, 0xffaa00, "Services")

        # Use soft lighting effect with light direction from the left
        layer.setBorderColor(ChartDirector::Transparent, ChartDirector::softLighting(
            ChartDirector::Left))

        # Set the x axis labels. In this example, the labels must be Jan - Dec.
        #labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct",
          #  "Nov", "Dec"]
     
       # labels = ["#{hardware [i]}"]
        #end
        #for i in 0..hardware.length 
        
        
         # Use 10 pts Arial Bold/green (0x008000) font for the x axis labels. Set the label 
         # angle to 45 degrees. 
         c.xAxis().setLabelStyle("arialbd.ttf", 10).setFontAngle(90)
        
        c.xAxis().setLabels(hardware)
        
        #c.xAxis().setLabels(labels)
        c.xAxis().setTitle("Days")
       # end

        # Draw the ticks between label positions (instead of at label positions)
        c.xAxis().setTickOffset(0.5)

        # Set the y axis title
        c.yAxis().setTitle("Number Of Customer")

        # Set axes width to 2 pixels
        c.xAxis().setWidth(2)
        c.yAxis().setWidth(2)

        # Output the chart in PNG format
        send_data(c.makeChart2(ChartDirector::PNG), :type => "image/png",
            :disposition => "inline")
          
      
      end
      

    def getchart()
        selectedYear = (params["year"] || 2001).to_i

        #
        # Query database for the selected year and read results into arrays
        #

        records = Revenue.find(:all, :conditions => ["Year(TimeStamp) = ?", selectedYear],
            :order => "TimeStamp")

        software = []
        hardware = []
        services = []
        records.each do |r|
            software.push(r.Software)
            hardware.push(r.Hardware)
            services.push(r.Services)
        end

        #
        # Now we have read data into arrays, we can draw the chart using ChartDirector
        #

        # Create a XYChart object of size 600 x 300 pixels, with a light grey (eeeeee)
        # background, black border, 1 pixel 3D border effect and rounded corners.
        c = ChartDirector::XYChart.new(600, 300, 0xeeeeee, 0x000000, 1)
        c.setRoundedFrame()

        # Set the plotarea at (60, 60) and of size 520 x 200 pixels. Set background color
        # to white (ffffff) and border and grid colors to grey (cccccc)
        c.setPlotArea(60, 60, 520, 200, 0xffffff, -1, 0xcccccc, 0xccccccc)

        # Add a title to the chart using 15pts Times Bold Italic font, with a light blue
        # (ccccff) background and with glass lighting effects.
        c.addTitle(sprintf("Global Revenue for Year %s", selectedYear), "timesbi.ttf", 15
            ).setBackground(0xccccff, 0x000000, ChartDirector::glassEffect())

        # Add a legend box at (70, 32) (top of the plotarea) with 9pts Arial Bold font
        c.addLegend(70, 32, false, "arialbd.ttf", 9).setBackground(
            ChartDirector::Transparent)

        # Add a stacked bar chart layer using the supplied data
        layer = c.addBarLayer2(ChartDirector::Stack)
        layer.addDataSet(software, 0xff0000, "Software")
        layer.addDataSet(hardware, 0x00ff00, "Hardware")
        layer.addDataSet(services, 0xffaa00, "Services")

        # Use soft lighting effect with light direction from the left
        layer.setBorderColor(ChartDirector::Transparent, ChartDirector::softLighting(
            ChartDirector::Left))

        # Set the x axis labels. In this example, the labels must be Jan - Dec.
        labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct",
            "Nov", "Dec"]
        c.xAxis().setLabels(labels)

        # Draw the ticks between label positions (instead of at label positions)
        c.xAxis().setTickOffset(0.5)

        # Set the y axis title
        c.yAxis().setTitle("USD (Millions)")

        # Set axes width to 2 pixels
        c.xAxis().setWidth(2)
        c.yAxis().setWidth(2)

        # Output the chart in PNG format
        send_data(c.makeChart2(ChartDirector::PNG), :type => "image/png",
            :disposition => "inline")
          end
          
          
          def getchartmodi()
            puts "modification ..........."
            puts params["user"]
            puts params[:date1]
            puts params[:date2]
            
            
            
        selectuser = params["user"]
        
        selectedYear = (params["year"] || 2001).to_i

        #
        # Query database for the selected year and read results into arrays
        #

        #records = Revenue.find(:all, :conditions => "
          #                                  and [login ='#{selectuser}" )


      #  records = Transact.find(:all, :conditions => " transdate<='#{params[:date2]}' and transdate>='#{params[:date1]}' 
        #                                    and login='#{selectuser}' " )
        
              sQL = "select avg(score) as score,serviceid  from transactmaster 
                                                          where  login='#{params["user"]}' 
                                                          and transdate<='#{params[:date2]}' and transdate>='#{params[:date1]}'
                                                          group by serviceid "
        
        
         records = Transact.find_by_sql(sQL)
        #records = Revenue.find(:all, :conditions => " TimeStamp<='#{params[:date2]}' and TimeStamp>='#{params[:date1]}' 
          #                                  and login='#{selectuser}' " )
                                            
    
        #records = Revenue.find(:all, :conditions => ["Year(TimeStamp) = ?", selectedYear],
        #    :order => "TimeStamp")

     #   software = []
      #  hardware = []
      #  services = []
        
        #records.each do |r|
          #  software.push(r.Software)
           # hardware.push(r.Hardware)
           # services.push(r.Services)
        #end

                software = []
        hardware = []
        services = []
        
        records.each do |r|
           puts  software.push(r.score)
          puts  hardware.push(r.serviceid)
          #  hardware.push(r.Hardware)
           # services.push(r.Services)
        end


      #for i in 0..hardware.length 
    #puts hardware [i]
    #end
    
        
        #
        # Now we have read data into arrays, we can draw the chart using ChartDirector
        #

        # Create a XYChart object of size 600 x 300 pixels, with a light grey (eeeeee)
        # background, black border, 1 pixel 3D border effect and rounded corners.
        c = ChartDirector::XYChart.new(700, 400, 0xeeeeee, 0x000000, 1)
        c.setRoundedFrame()

        # Set the plotarea at (60, 60) and of size 520 x 200 pixels. Set background color
        # to white (ffffff) and border and grid colors to grey (cccccc)
        c.setPlotArea(60, 100, 520, 200, 0xffffff, -1, 0xcccccc, 0xccccccc)

        # Add a title to the chart using 15pts Times Bold Italic font, with a light blue
        # (ccccff) background and with glass lighting effects.
        c.addTitle(sprintf("Employee Score Card For %s", selectuser), "timesbi.ttf", 15
            ).setBackground(0xccccff, 0x000000, ChartDirector::glassEffect())

        # Add a legend box at (70, 32) (top of the plotarea) with 9pts Arial Bold font
        c.addLegend(70, 32, false, "arialbd.ttf", 9).setBackground(
            ChartDirector::Transparent)

        # Add a stacked bar chart layer using the supplied data
        layer = c.addBarLayer2(ChartDirector::Stack)
        layer.addDataSet(software, 0xff0000, "Employee Score / Services")
        # layer.addDataSet( 0xff0000, "Employee Score / Services")
        #layer.addDataSet(hardware, 0x00ff00, "Hardware")
        #layer.addDataSet(services, 0xffaa00, "Services")

        # Use soft lighting effect with light direction from the left
        layer.setBorderColor(ChartDirector::Transparent, ChartDirector::softLighting(
            ChartDirector::Left))
            
            
            
          # Configure the sector labels using CDML to include the icon images 
        #  c.setLabelFormat( "<block,valign=absmiddle*><*img={field0}> <*block*>{label}\n{percent}%" \ "<*/*><*/*>")


        # Set the x axis labels. In this example, the labels must be Jan - Dec.
        #labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct",
          #  "Nov", "Dec"]
     
       # labels = ["#{hardware [i]}"]
        #end
        #for i in 0..hardware.length 
         
         # Use 10 pts Arial Bold/green (0x008000) font for the x axis labels. Set the label 
         # angle to 45 degrees. 
         c.xAxis().setLabelStyle("arialbd.ttf", 10).setFontAngle(0)
          
          #c.xAxis().setLabels(labels)
        c.xAxis().setLabels(hardware)
        
        #c.xAxis().setLabels(labels)
        c.xAxis().setTitle("Services")
        
       # end

        # Draw the ticks between label positions (instead of at label positions)
        c.xAxis().setTickOffset(0.5)

        # Set the y axis title
        c.yAxis().setTitle("Employee Score")

        # Set axes width to 2 pixels
        c.xAxis().setWidth(2)
        c.yAxis().setWidth(2)

        # Output the chart in PNG format
        send_data(c.makeChart2(ChartDirector::PNG), :type => "image/png",
            :disposition => "inline")
          end
          
          
          
          
          
            
  end
   