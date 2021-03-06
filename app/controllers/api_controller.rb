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
      format.js { render_json_with_callback @entities.to_json }
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
    entity_id = params[:entity_id]
#    max_id = params[:max_id] unless params[:max_id]
    if since_id.nil?
      comments = Comment.find :all,
        :conditions=>["comment_id = -1 and entity_id = ?", entity_id],
        :order=>"id ASC",
        :limit=>count
    else
      comments = Comment.find :all,
        :conditions => [" id > ? and comment_id = -1 and entity_id = ?", since_id, entity_id],
        :order=>"id ASC",
        :limit=>count
    end


    json_array = []
    comments.each do |comment|
        user = User.find comment.user_id
        json_array << {:comment=>{:created_at=>"#{comment.created_at}",:image_url=>"#{comment.image_url}",
            :username=>"#{user.login}", :user_image=>"#{user.user_image}", :description=>"#{comment.description}",
            :comment_id=>comment.id, :category_id=>comment.category_id,
            :counter=>comment.comments_counter,
            :important_tag=>comment.important_tag,
            :entity_id=>comment.entity_id}}
    end

    json_string = ActiveSupport::JSON.encode(json_array)

    respond_to do |format|
      format.json { render :json => json_string }
    end
  end

  def get_comment_categories
    @categories = CommentCategory.find :all, :order=> 'created_at'

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
      responses = Comment.find :all,
        :conditions => ["comment_id = ?", comment_id],
        :order=>"id ASC",
        :limit=>count
    else
      responses = Comment.find :all,
        :conditions => [" id > ? and comment_id = ?", since_id, comment_id],
        :order=>"id ASC",
        :limit=>count
    end

    json_array = []
    responses.each do |response|
        user = User.find response.user_id
        json_array << {:comment=>{:created_at=>"#{response.created_at}",:image_url=>"#{response.image_url}",
            :username=>"#{user.login}", :user_image=>"#{user.user_image}", :description=>"#{response.description}",
            :comment_id=>response.comment_id, :id=>response.id,
            :counter=>response.comments_counter,
            :important_tag=>response.important_tag,
            :category_id=>response.category_id}}
    end

    json_string = ActiveSupport::JSON.encode(json_array)

    respond_to do |format|
      format.json { render :json => json_string }
    end
  end

  def get_response_categories
    @categories = ResponseCategory.find :all, :order=> 'created_at'

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

  #Verify user password information
  def verify_user_information
    respond_to do |format|
      if params[:username] && params[:password]
        user = User.find_by_login params[:username]
        unless user
          format.json  { render :json => "incorrect user name or password", :status => :unprocessable_entity }
          format.xml  { render :xml => "incorrect user name or password", :status => :unprocessable_entity }
        end
        
        if user.valid_password? params[:password]
          format.json  { render :json => user, :status => :created, :location => user }
          format.xml { render :xml => user, :status => :created, :location => user }
        else
          format.json  { render :json => "incorrect user name or password", :status => :unprocessable_entity }
          format.xml  { render :xml => "incorrect user name or password", :status => :unprocessable_entity }
        end
      else
        format.json  { render :json => "incorrect user name or password", :status => :unprocessable_entity }
        format.xml  { render :xml => "incorrect user name or password", :status => :unprocessable_entity }
      end
    end
  end

  #Get categories counters by entity id
  def get_comment_categories_counters
    entity_id = -2
    entity_id = params[:entity_id] if params[:entity_id]

    counters = EntityCategoryCounter.find :all,
        :conditions => ["entity_id = ?", entity_id],
        :order=>"comment_category_id ASC"

    respond_to do |format|
      format.json { render :json => counters }
      format.xml  { render :xml => counters }
    end
  end

  #Get categories counters by comment id
  def get_response_categories_counters
    comment_id = -2
    comment_id = params[:comment_id] if params[:comment_id]

    counters = CommentCategoryCounter.find :all,
        :conditions => ["comment_id = ?", comment_id],
        :order=>"response_category_name ASC"

    respond_to do |format|
      format.json { render :json => counters }
      format.xml  { render :xml => counters }
    end
  end

  #Generate kml content
  def geoinformation
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
    <styleUrl>#}+entity.icon_name+%{</styleUrl>
    <name>}+entity.title+%{</name>
    <description>
      <![CDATA[
          <div style="width: 264px;max-height:250px;overflow:auto;">
            <div style="font-size: small; margin-top: 4px; ">
            <p>}+entity.description+%{</p>
            </div>
          </div>
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

    
    render :xml => kml
  end
  
  
  private
  def render_json_with_callback(json, options={})
    # support callback on json
    callback = params[:callback]

    response = begin
      if callback
        "#{callback}(#{json});"
      else
        json
      end
    end
    render({:content_type => :js, :text => response}.merge(options))
  end

end
