
#An unpublished work of Sprylogic Technologies Ltd. 
# © Copyright Sprylogic Technologies Ltd. 2008. All rights reserved 
class ReportsController < ApplicationController
   #require 'csv'
#require 'fastercsv'
before_filter :login_required


   
  def counter_report
  puts "-------------------------------------------------------------------------"
  @start_date = Date.civil(params[:range][:"start_date(1i)"].to_i,params[:range][:"start_date(2i)"].to_i,params[:range][:"start_date(3i)"].to_i)
  @end_date = Date.civil(params[:range][:"end_date(1i)"].to_i,params[:range][:"end_date(2i)"].to_i,params[:range][:"end_date(3i)"].to_i)
  puts(@start_date)
  puts "-----------------------------------------------------------------------------------------------------------------"
  puts (@end_date)
  puts "-------------------------------------------------------------------------------------------------------------------"
 
   	t_count=Transact.find_by_sql("select distinct counterno as ctno from transacts")
   	puts "before"
   	puts t_count
   	da=Date.today
    Dir.chdir('C:\ROR\InstantRails\rails_apps\DQMS\Reports\Counter_Wise_Report')
  
   	for item in t_count
         	count=item.ctno
         	puts "After"
         	puts item.ctno
         	#a=item.ctno
         	users = Transact.find_by_sql("select counterno,tokenno,calledtime ,servicedtime,timetaken,servicename 
						from transacts t,services s 
						where s.serviceid=t.serviceid and counterno=#{item.ctno}")
				m=Transact.find_by_sql("select avg(servicedtime) as Avg_Time from transacts where counterno=#{item.ctno}")     
						for item in m
							d=item.Avg_Time
						end
						
						gen_file(da,users,d,count)
						#stream_csv do |csv|
						#	csv<<  "Reports"
						#csv << ['Counterno','Tokenno','Calledtime' ,'Servicedtime','Timetaken','Servicename ']
						#users.each do |u|
							#	csv << [u.counterno,u.tokenno,u.calledtime ,u.servicedtime,u.timetaken,u.servicename ]
							#end	                   
    				#end
    	end
    	
      Dir.chdir('C:\ROR\InstantRails\rails_apps\DQMS')

end

def gen_file(fir,sec,last,t_count)
one=fir.to_s+".txt" 
header=['Tokenno','    ','Calledtime','                    ' ,'Servicedtime','                        ','Timetaken','                  ','Servicename ']
   if File.exists?(one)
      fp=File.open(fir.to_s+".txt","a+") 
      fp.write("Counter No:---\t")
      fp.write (t_count)
      fp.write("\n")
      fp.write("----------------------------------------------------------------------------------------------------------------------------------------------------------------------------")
      fp.write("\n")
      fp.write(header)
      fp.write("\n")
      fp.write("----------------------------------------------------------------------------------------------------------------------------------------------------------------------------")
      fp.write("\n")
      	fp.write("\n")
      sec.each do |u|
      puts u.servicedtime
      	
      	
       	fp.write(u.tokenno)
      	fp.write("\t")
       	fp.write(u.calledtime)
       	fp.write("\t")
      	fp.write(u.servicedtime)
      	fp.write("\t")
      	fp.write(u.timetaken)
      	fp.write("\t")
      	fp.write(u.servicename)
      	fp.write("\n")
      	#u.tokenno,u.calledtime ,u.servicedtime,u.timetaken,u.servicename )
      end
      	fp.write("\n")
      	puts "mean time is ---------#{last}"
      	 @time=0
	            #puts "mean time111 is ---------#{last}"
	      	     @Hours = (last.to_i / (1000*60*60))
	      	     if @Hours <=9
	      	     @Hours="0"+@Hours.to_s 
	      	     end
	      	     @Minutes = (last.to_i % (1000*60*60)) / (1000*60)
	      	     if @Minutes <=9
		     @Minutes="0"+@Minutes.to_s 
	      	     end
	             @Seconds = (((last.to_i % (1000*60*60)) % (1000*60)) / 1000)
	             if @Seconds <=9
		     @Seconds= "0"+@Seconds.to_s 
	      	     end
		@time=@Hours.to_s+":"+@Minutes.to_s+":"+@Seconds.to_s
	
	 fp.write("-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------")
	fp.write("\n")
	 fp.write("\t")
		 fp.write("\t")
		 fp.write("\t")
		 fp.write("\t")
		 fp.write("\t")
		 fp.write("\t")
		 fp.write("\t")
		 fp.write("\t")
		 fp.write("\t")
		 fp.write("\t")
	 fp.write("\t")
	fp.write("Average Mean Time-------")
	fp.write(@time) 
	fp.write("\n")
	
	fp.write("-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------")
        fp.write("\n")
      	#fp.write(last)
      	fp.write("\n")
      	fp.write("\n")
      	fp.close
   else
       fp=File.new(fir.to_s+".txt","a+") 
       	     fp.write("\t")
	    	 fp.write("\t")
	    	 fp.write("\t")
	    	 fp.write("\t")
	    	 fp.write("\t")
	    	 fp.write("\t")
	    	 fp.write("\t")
	 fp.write("Counter Wise Report ")
	 fp.write("\n")
	 fp.write("\n")
            fp.write("Counter No:---\t")
	    fp.write (t_count)
       	    fp.write("\n")
     	    fp.write("-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------")
     	    fp.write("\n")
            fp.write(header)
            fp.write("\n")
	    fp.write("------------------------------------------------------------------------------------------------------------------------------------------------------------------------------")
	    fp.write("\n")
             sec.each do |u|
             puts u.servicedtime
             
      		
       	      	fp.write(u.tokenno)
	      	fp.write("\t")
	       	fp.write(u.calledtime)
	       	fp.write("\t")
	      	fp.write(u.servicedtime)
	      	fp.write("\t")
	      	fp.write(u.timetaken)
	      	fp.write("\t")
      		fp.write(u.servicename)
      		fp.write("\n")
             	fp.write("\n")
             	#,u.tokenno,u.calledtime ,u.servicedtime,u.timetaken,u.servicename )
             end
            fp.write("\n")
            @time=0
            #puts "mean time111 is ---------#{last}"
      	      @time=0
	     	  @Hours = (last.to_i / (1000*60*60))
	     	  if @Hours <=9
	  	  @Hours="0"+@Hours.to_s 
	          end
		  @Minutes = (last.to_i % (1000*60*60)) / (1000*60)
		  if @Minutes <=9
		  @Minutes="0"+@Minutes.to_s 
		  end
		  @Seconds = (((last.to_i % (1000*60*60)) % (1000*60)) / 1000)
	 	  if @Seconds <=9
		  @Seconds="0"+@Seconds.to_s 
	      	  end
		@time=@Hours.to_s+":"+@Minutes.to_s+":"+@Seconds.to_s
	@time=@Hours.to_s+":"+@Minutes.to_s+":"+@Seconds.to_s
	 
	    fp.write("---------------------------------------------------------------------------------------------------------------------------------------")
		fp.write("\n")
		   fp.write("\t")
			    fp.write("\t")
			    fp.write("\t")
			    fp.write("\t")
			    fp.write("\t")
			    fp.write("\t")
			    fp.write("\t")
			    fp.write("\t")
			    fp.write("\t")
			    fp.write("\t")
	    fp.write("\t")
	    fp.write("Average Mean Time-------")
	    fp.write(@time) 
	    fp.write("\n")
	    fp.write("---------------------------------------------------------------------------------------------------------------------------------------")
      	    fp.write("\n")
      	    #fp.write(last)
      	    fp.write("\n")
      	    fp.write("\n")
      	    fp.close
   end
   
   
end

 #private
  #  def stream_csv
   #    filename = params[:action] + ".csv"    
    #    #csv<< REPORTS 
       
     #    headers["Content-Type"] ||= 'text/csv'
      #   headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
      
#
#headers("Cache-Control: must-revalidate, post-check=0, pre-check=0");
#
#headers("Content-Disposition: attachment; filename=report.csv");
#
#headers("Pragma: no-cache");
#
#headers("Expires: 0");

      #render :text => Proc.new { |response, output|
       # csv = FasterCSV.new(output, :row_sep => "\r\n") 
        #yield csv
      #}
    #end

end
