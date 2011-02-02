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
    rss = %{<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
  <name>US State Capitals</name>
  <description><![CDATA[]]></description>
  <Placemark>
    <name>Alabama</name>
    <description><![CDATA[Montgomery]]></description>
    <Style id="downArrowIcon">
      <IconStyle>
        <Icon>
          <href>http://www.chilliwackteachers.com/images/maps_icon.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Point>
      <coordinates>-86.300568,32.377716,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Alaska</name>
    <description><![CDATA[Juneau]]></description>
    <Style id="downArrowIcon">
      <IconStyle>
        <Icon>
          <href>http://www.chilliwackteachers.com/images/maps_icon.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Point>
      <coordinates>-134.420212,58.301598,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Arizona</name>
    <description><![CDATA[Phoenix]]></description>
    <Style id="downArrowIcon">
      <IconStyle>
        <Icon>
          <href>http://www.chilliwackteachers.com/images/maps_icon.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Point>
      <coordinates>-112.096962,33.448143,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Arkansas</name>
    <description><![CDATA[Little Rock]]></description>
    <Style id="downArrowIcon">
      <IconStyle>
        <Icon>
          <href>http://www.chilliwackteachers.com/images/maps_icon.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Point>
      <coordinates>-92.288986,34.746613,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>California</name>
    <description><![CDATA[Sacramento]]></description>
    <Style id="downArrowIcon">
      <IconStyle>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/pal4/icon28.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Point>
      <coordinates>-121.493629,38.576668,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Colorado</name>
    <description><![CDATA[Denver]]></description>
    <Style id="downArrowIcon">
      <IconStyle>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/pal4/icon28.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Point>
      <coordinates>-104.984856,39.739227,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Connecticut</name>
    <description><![CDATA[Hartford<br>]]></description>
    <Point>
      <coordinates>-72.682198,41.764046,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Delaware</name>
    <description><![CDATA[Dover]]></description>
    <Point>
      <coordinates>-75.519722,39.157307,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Hawaii</name>
    <description><![CDATA[Honolulu]]></description>
    <Point>
      <coordinates>-157.857376,21.307442,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Florida</name>
    <description><![CDATA[Tallahassee]]></description>
    <Point>
      <coordinates>-84.281296,30.438118,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Georgia</name>
    <description><![CDATA[Atlanta<br>]]></description>
    <Point>
      <coordinates>-84.388229,33.749027,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Idaho</name>
    <description><![CDATA[Boise]]></description>
    <Point>
      <coordinates>-116.199722,43.617775,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Illinois</name>
    <description><![CDATA[Springfield]]></description>
    <Point>
      <coordinates>-89.654961,39.798363,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Indiana</name>
    <description><![CDATA[Indianapolis]]></description>
    <Point>
      <coordinates>-86.162643,39.768623,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Iowa</name>
    <description><![CDATA[Des Moines]]></description>
    <Point>
      <coordinates>-93.603729,41.591087,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Kansas</name>
    <description><![CDATA[Topeka]]></description>
    <Point>
      <coordinates>-95.677956,39.048191,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Kentucky</name>
    <description><![CDATA[Frankfort]]></description>
    <Point>
      <coordinates>-84.875374,38.186722,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Louisiana</name>
    <description><![CDATA[Baton Rouge]]></description>
    <Point>
      <coordinates>-91.187393,30.457069,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Maine</name>
    <description><![CDATA[Augusta]]></description>
    <Point>
      <coordinates>-69.781693,44.307167,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Maryland</name>
    <description><![CDATA[Annapolis]]></description>
    <Point>
      <coordinates>-76.490936,38.978764,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Massachusetts</name>
    <description><![CDATA[Boston]]></description>
    <Point>
      <coordinates>-71.063698,42.358162,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Michigan</name>
    <description><![CDATA[Lansing]]></description>
    <Point>
      <coordinates>-84.555328,42.733635,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Minnesota</name>
    <description><![CDATA[St. Paul]]></description>
    <Point>
      <coordinates>-93.102211,44.955097,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Mississippi</name>
    <description><![CDATA[Jackson]]></description>
    <Point>
      <coordinates>-90.182106,32.303848,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Missouri</name>
    <description><![CDATA[Jefferson City]]></description>
    <Point>
      <coordinates>-92.172935,38.579201,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Montana</name>
    <description><![CDATA[Helena]]></description>
    <Point>
      <coordinates>-112.018417,46.585709,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Nebraska</name>
    <description><![CDATA[Lincoln]]></description>
    <Point>
      <coordinates>-96.699654,40.808075,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Nevada</name>
    <description><![CDATA[Carson City]]></description>
    <Point>
      <coordinates>-119.766121,39.163914,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>New Hampshire</name>
    <description><![CDATA[Concord]]></description>
    <Point>
      <coordinates>-71.537994,43.206898,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>New Jersey</name>
    <description><![CDATA[Trenton]]></description>
    <Point>
      <coordinates>-74.769913,40.220596,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>New Mexico</name>
    <description><![CDATA[Santa Fe]]></description>
    <Point>
      <coordinates>-105.939728,35.682240,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>North Carolina</name>
    <description><![CDATA[Raleigh]]></description>
    <Point>
      <coordinates>-78.639099,35.780430,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>North Dakota</name>
    <description><![CDATA[Bismarck]]></description>
    <Point>
      <coordinates>-100.783318,46.820850,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>New York</name>
    <description><![CDATA[Albany]]></description>
    <Point>
      <coordinates>-73.757874,42.652843,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Ohio</name>
    <description><![CDATA[Columbus]]></description>
    <Point>
      <coordinates>-82.999069,39.961346,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Oklahoma</name>
    <description><![CDATA[Oklahoma City]]></description>
    <Point>
      <coordinates>-97.503342,35.492207,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Oregon</name>
    <description><![CDATA[Salem]]></description>
    <Point>
      <coordinates>-123.030403,44.938461,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Pennsylvania</name>
    <description><![CDATA[Harrisburg]]></description>
    <Point>
      <coordinates>-76.883598,40.264378,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Rhode Island</name>
    <description><![CDATA[Providence]]></description>
    <Point>
      <coordinates>-71.414963,41.830914,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>South Carolina</name>
    <description><![CDATA[Columbia]]></description>
    <Point>
      <coordinates>-81.033211,34.000343,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>South Dakota</name>
    <description><![CDATA[Pierre]]></description>
    <Point>
      <coordinates>-100.346405,44.367031,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Tennessee</name>
    <description><![CDATA[Nashville]]></description>
    <Point>
      <coordinates>-86.784241,36.165810,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Texas</name>
    <description><![CDATA[Austin]]></description>
    <Point>
      <coordinates>-97.740349,30.274670,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Utah</name>
    <description><![CDATA[Salt Lake City]]></description>
    <Point>
      <coordinates>-111.888237,40.777477,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Vermont</name>
    <description><![CDATA[Montpelier]]></description>
    <Point>
      <coordinates>-72.580536,44.262436,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Virginia</name>
    <description><![CDATA[Richmond]]></description>
    <Point>
      <coordinates>-77.433640,37.538857,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Washington</name>
    <description><![CDATA[Olympia]]></description>
    <Point>
      <coordinates>-122.905014,47.035805,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>West Virginia</name>
    <description><![CDATA[Charleston]]></description>
    <Point>
      <coordinates>-81.612328,38.336246,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Wisconsin</name>
    <description><![CDATA[Madison]]></description>
    <Point>
      <coordinates>-89.384445,43.074684,0.000000</coordinates>
    </Point>
  </Placemark>
  <Placemark>
    <name>Wyoming</name>
    <description><![CDATA[Cheyenne]]></description>
    <Point>
      <coordinates>-104.820236,41.140259,0.000000</coordinates>
    </Point>
  </Placemark>
</Document>
</kml>
}

    render :text => rss
  end

end
