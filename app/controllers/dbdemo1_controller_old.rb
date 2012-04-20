#require("chartdirector")

class Dbdemo1Controller < ApplicationController
  layout 'accounts'
    def index()
        
=begin        @ctrl_file = File.expand_path(__FILE__)

        begin
            # Detect if the database bas been set up
            dummy = Revenue.find(:first)
        rescue Exception
            # Cannot access data => return set up message
            @title = "Database Integration Demo (1)"
            @errmsg = $!
            
            render :template => "templates/dbsetup"
        end
=end        
      end
      
      
      def selection()
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
        puts "123"
      
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
