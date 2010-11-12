class RespsApiController < ApplicationController
  def get_resps_by_entity_id
    @resps = Resp.find_all_by_entity_id params[:entity_id], :limit=>10, :offset=>20

    respond_to do |format|
      format.html
      format.xml  { render :xml => @resps }
      format.json { render :json => @resps }
    end
  end

  def get_resps_by_entity_id_and_time

    @resps = Resp.find_all_by_entity_id params[:entity_id],
      :conditions => [" time > ? ", params[:time]], :limit=>10
    
    respond_to do |format|
      format.html {render :get_resps_by_entity_id}
      format.xml  { render :xml => @resps }
      format.json { render :json => @resps }
    end
  end

end
