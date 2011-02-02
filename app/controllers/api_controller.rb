class ApiController < ApplicationController
#  before_filter :require_http_auth_user

  #return 10 most recent entities to a certain user
  #the id of certain user is store in the session[:current_user_id]
  def get_recent_entities
    user = User.find(session[:current_user_id])
    user_latest_accessed_entity_at = user.current_entity_time

    @entities = Entity.find :all,
#      :conditions => " created_at > 2010-10-08T07:59:46Z", :limit=>10
      :conditions => [" created_at > ? ", user_latest_accessed_entity_at]
#http://localhost:3000/entities_api/get_recent_entities.json?time=%222010-10-08T07:59:46Z%22

    session[:current_user_id] = nil

    respond_to do |format|
      format.xml  { render :xml => @entities }
      format.json { render :json => @entities }
    end
  end

  def get_comments_by_entity_and_category
    category_id = CommentCategory.find_by_name params[:category]
    comments = Comment.find_all_by_entity_id_and_category_id 1,1# params[:entity_id], category_id

    json_array = []
    comments.each do |comment|
        user = User.find comment.user_id
        json_array << {:comment=>{:created_at=>"#{comment.created_at}",:image_url=>"#{comment.image_url}",
            :username=>"#{user.login}", :user_image=>"#{user.user_image}", :description=>"#{comment.description}",
            :comment_id=>comment.id}}
    end

    json_string = ActiveSupport::JSON.encode(json_array)

    respond_to do |format|
      format.json { render :json => json_string }
    end
  end

  def get_comments_by_comment_id
    comments = Comment.find_all_by_comment_id_and_type

    json_array = []
    comments.each do |comment|
        user = User.find comment.user_id
        json_array << {:comment=>{:created_at=>"#{comment.created_at}",:image_url=>"#{comment.image_url}",
            :username=>"#{user.login}", :user_image=>"#{user.user_image}", :description=>"#{comment.description}",
            :comment_id=>comment.id}}
    end

    json_string = ActiveSupport::JSON.encode(json_array)

    respond_to do |format|
      format.json { render :json => json_string }
    end
  end


  #new defined api
  #Resource: Get list of entities
  #Method: Get
  #Url: http://geotagging.heroku.com/api/entities.[json|xml]
  #Parameters:
  #count (optonal) the number of entities return by the request. default 20
  #
  #	e.g. http://geotagging.heroku.com/api/entities.json?count=10
  #since_id (optional) return the entities that have id larger than this number
  #
  #	e.g. http://geotagging.heroku.com/api/entities.json?since_id=29332
  #max_id (optional) return the entities that have id smaller than this number
  def get_entities
    count = 20
    count = params[:count] if params[:count]
    since_id = params[:since_id] if params[:since_id]
#    max_id = params[:max_id] unless params[:max_id]
    if since_id.nil?
      @entities = Entity.find :all, :limit=>count
    else
      @entities = Entity.find :all,
        :conditions => [" id > ? ", since_id], :limit=>count
    end
    
    respond_to do |format|
      format.xml  { render :xml => @entities }
      format.json { render :json => @entities }
    end
  end

  #Resource: Get list of comments for an entity
  #Method: Get
  #Url: http://geotagging.heroku.com/api/comments.[json|xml]
  #Parameters:
  #entity_id (require)
  #category (require)
  #
  #e.g.http://geotagging.heroku.com/api/comments.json?entity_id=2343&category=”Request for Help”
  #count (optonal) the number of entities return by the request. default 20
  #since_id
  #max_id
  def get_comments
    count = 20
    count = params[:count] if params[:count]
    since_id = params[:since_id] if params[:since_id]
#    max_id = params[:max_id] unless params[:max_id]
    if since_id.nil?
      @comments = Comment.find :all,
        :conditions=>["comment_id = -1"],
        :limit=>count
    else
      @comments = Comment.find :all,
        :conditions => [" id > ? and comment_id = -1", since_id], :limit=>count
    end

    respond_to do |format|
      format.xml  { render :xml => @comments }
      format.json { render :json => @comments }
    end
  end

  def get_comment_categories
    @categories = CommentCategory.all

    respond_to do |format|
      format.xml  { render :xml => @categories }
      format.json { render :json => @categories }
    end
  end

  #Resource: Get list of responses for a comment
  #Method: Get
  #Url: http://geotagging.heroku.com/api/responses.[json|xml]
  #Parameters:
  #comment_id (require)
  #category (require)
  #e.g. http://geotagging.heroku.com/api/responses.json?comment_id=2343&category=”Big Picture”
  #count (optonal) the number of entities return by the request. default 20
  #since_id
  #max_id
  def get_responses
    count = 20
    count = params[:count] if params[:count]

    comment_id = params[:comment_id]

    since_id = params[:since_id] if params[:since_id]
#    max_id = params[:max_id] unless params[:max_id]
    if since_id.nil?
      @responses = Comment.find :all,
        :conditions => ["comment_id = ?", comment_id],
        :limit=>count
    else
      @responses = Comment.find :all,
        :conditions => [" id > ? and comment_id = ?", since_id, comment_id],
        :limit=>count
    end

    respond_to do |format|
      format.xml  { render :xml => @responses }
      format.json { render :json => @responses }
    end
  end

  def get_response_categories
    @categories = ResponseCategory.all

    respond_to do |format|
      format.xml  { render :xml => @categories }
      format.json { render :json => @categories }
    end
  end

  def create_entity
    @entity = Entity.new(params[:entity])

    respond_to do |format|
      if @entity.save
        format.xml  { render :xml => @entity, :status => :created, :location => @entity }
        format.json { render :json => @entity, :status => :created, :location => @entity }
      else
        format.xml  { render :xml => @entity.errors, :status => :unprocessable_entity }
        format.json { render :json => @entity.errors, :status => :unprocessable_entity }
      end
    end
  end

  def create_comment
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        format.json { render :json => @comment, :status => :created, :location => @comment }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.json { render :json => @comment.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  #Generate georss stuff
  def georss
    iconstyles = ""
    icons = Icon.all
    icons.each do |icon|
      iconstyles = iconstyles +
%{  <Style id="}+icon.name+%{">
    <IconStyle>
      <Icon>
        <href>}+icon.url+%{</href>
      </Icon>
    </IconStyle>
  </Style>
}
    end

    kml = %{<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
  <name>Semantatic Geotagging</name>
  <description><![CDATA[]]></description>
}
    kml = kml + iconstyles
    entities = Entity.all
    entities.each do |entity|
      kml = kml +
%{
  <Placemark>
    <name>}+entity.title+%{</name>
    <styleUrl>#}+entity.icon_uri+%{</styleUrl>
    <description>
      <![CDATA[
        <h1>CDATA Tags are useful!</h1>
        <p>}+entity.description+%{</p>
      ]]>
    </description>
    <Point>
      <coordinates>}+entity.lng.to_s+%{,}+entity.lat.to_s+%{,0.000000</coordinates>
    </Point>
  </Placemark>}
    end

    kml = kml +
%{
</Document>
</kml>
}

    render :text=>kml
  end

end
