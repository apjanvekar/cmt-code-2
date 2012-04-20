class AdminController < ApplicationController
  require 'fileutils'
  require 'soap/wsdlDriver'
  require 'rexml/document'
  include REXML

    def getData
    file = File.new("D:/DQM_XML.xml")
    doc = Document.new(file)
    @cmt_server_ip= doc.root.elements[1].elements["CMT_SERVER_IP"].text
    @cmt_server_port=doc.root.elements[1].elements["CMT_PORT"].text
   puts @items=Transact.find(:all,:conditions=>["flag=? and tokenstatus<>?",'N',4],:limit=>'25') ##send the tokens which have not been send and which are locked at any counter with status 4,limiting max rows to be sent to 100 around 200KB of data at one go
    if @items.any?
        puts wsdl = "http://#{@cmt_server_ip}:#{@cmt_server_port}/hello/wsdl"
        puts hello_client = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver 
        for item in @items
               puts @value = hello_client.getData(
                         item.tokenno,
                         item.tokenid,
                         item.ctypeid,
                         item.transdate,
                         item.generatedtime,
                         item.serviceid,
                         item.counterno,
                         item.accno,
                         item.login,
                         item.calledtime,
                         item.servicedtime,
                         item.timetaken,
                         item.waittime,
                         item.stpname,
                         item.nonstpname,
                         item.tokenstatus,
                         item.pausetime,
                         item.releasetime,
                         item.bulkcount,
                         item.call1,
                         item.reasons,
                         item.actcode,
                         item.soleid,
                         item.serverstatus,
                         item.barcodetokens
                    )
                    if @value == "true" 
                        @data1=Transact.update(item.id,{:flag=>'Y'}) ##Change flag status after data sucessfully send to CMT
                    end
        end
              
    end
    
    end
end
