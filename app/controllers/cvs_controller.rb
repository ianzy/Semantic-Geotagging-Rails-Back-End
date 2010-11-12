require 'csv'

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
       resp = Resp.new(:entity_id=>entity_id,:username=>row[1],:time=>time, :resp=>row[4],
       :lang=>row[5],:image=>row[6],:source=>row[6],:location=>'',:lat=>row[8],:lng=>row[9])
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
