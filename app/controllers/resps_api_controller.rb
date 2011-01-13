require 'base64'
class RespsApiController < ApplicationController
  def get_resps_by_entity_id
    @resps = Resp.find_all_by_entity_id params[:entity_id], :limit=>10, :offset=>20
    @resps.each do |r|
        r.username = Base64::decode64(r.username)
        r.resp = Base64::decode64(r.resp)
        r.lang = Base64::decode64(r.lang)
        r.image = Base64::decode64(r.image)
        r.source = Base64::decode64(r.source)
        r.location = Base64::decode64(r.location)
    end
    respond_to do |format|
      format.html
      format.xml  { render :xml => @resps }
      format.json { render :json => @resps }
    end
  end

  def get_resps_by_entity_id_and_time

    @resps = Resp.find_all_by_entity_id params[:entity_id],
      :conditions => [" time > ? ", params[:time]], :limit=>10

    @resps.each do |r|
        r.username = Base64::decode64(r.username)
        r.resp = Base64::decode64(r.resp)
        r.lang = Base64::decode64(r.lang)
        r.image = Base64::decode64(r.image)
        r.source = Base64::decode64(r.source)
        r.location = Base64::decode64(r.location)
    end
    respond_to do |format|
      format.html {render :get_resps_by_entity_id}
      format.xml  { render :xml => @resps }
      format.json { render :json => @resps }
    end
  end

  #test how sql works
  def get_resps_by_minid
    @resps = Resp.find_all_by_entity_id 5,
      :conditions => [" id > ?", params[:minid]], :limit=>10

    @resps.each do |r|
        r.username = Base64::decode64(r.username)
        r.resp = Base64::decode64(r.resp)
        r.lang = Base64::decode64(r.lang)
        r.image = Base64::decode64(r.image)
        r.source = Base64::decode64(r.source)
        r.location = Base64::decode64(r.location)
    end
    respond_to do |format|
      format.html {render :get_resps_by_minid}
      format.xml  { render :xml => @resps }
      format.json { render :json => @resps }
    end
  end

end
