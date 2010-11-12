require 'csv'
require 'base64'

class CvsController < ApplicationController
  def index
  end

  def cvs_import
    @output = []
     @parsed_file=CSV::Reader.parse(params[:dump][:file])
     n=0
     entity_id = 5
     @parsed_file.each  do |row|
       puts "#{row}"
       @output<<row
       time = row[2]+" "+row[3]
       resp = Resp.new(:entity_id=>entity_id,:username=>Base64::encode64(row[1]),:time=>Base64::encode64(time), :resp=>Base64::encode64(row[4]),
       :lang=>Base64::encode64(row[5]),:image=>Base64::encode64(row[6]),:source=>Base64::encode64(row[6]),:location=>Base64::encode64(row[7]),:lat=>Base64::encode64(row[8]),:lng=>Base64::encode64(row[9]))
       if resp.save
         n=n+1
         if n%50 == 0
           GC.start
           entity_id = entity_id+1
         end
       end
       flash.now[:message]="CSV Import Successful,  #{n} new records added to data base"
     end
  end

end
