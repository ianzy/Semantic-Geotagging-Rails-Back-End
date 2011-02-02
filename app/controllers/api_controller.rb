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
      %{
        <Style id="}+icon.name+%{">
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
  <description><![CDATA[]]></description>}
    kml = kml + iconstyles
    entities = Entity.all
    entities.each do |entity|
      kml = kml +
      %{
        <Placemark>
          <name>}+entity.title+%{</name>
          <styleUrl>#}+entity.icon_uri+%{</styleUrl>
          <description><![CDATA[}+entity.description+%{]]></description>
          <Point>
            <coordinates>}+entity.lat.to_s+%{,}+entity.lng.to_s+%{,0.000000</coordinates>
          </Point>
        </Placemark>
      }
    end

    kml = kml + %{
      </Document>
    </kml>
    }

    test = %{<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
  <name>Semantatic Geotagging</name>
  <description><![CDATA[]]></description>
        <Style id="fireicon">
          <IconStyle>
            <Icon>
              <href>http://geotagging.heroku.com/images/icons/FireIcon_small.png</href>
            </Icon>
          </IconStyle>
        </Style>
        <Style id="landslide">
          <IconStyle>
            <Icon>
              <href>http://geotagging.heroku.com/images/icons/Landslide.png</href>
            </Icon>
          </IconStyle>
        </Style>
        <Placemark>
          <name>Fire1</name>
          <styleUrl>#fireicon</styleUrl>
          <description><![CDATA[Fire inbayshore sunnyvale golf course
Mountain View, CA 94043]]></description>
          <Point>
            <coordinates>37.396892,-122.041969,0.000000</coordinates>
          </Point>
        </Placemark>

        <Placemark>
          <name>Smoke</name>
          <styleUrl>#fireicon</styleUrl>
          <description><![CDATA[Smoke in 489-499 Carnegie Mellon Silicon Valley
Mountain View, CA 94043]]></description>
          <Point>
            <coordinates>37.409948,-122.059822,0.000000</coordinates>
          </Point>
        </Placemark>

        <Placemark>
          <name>Plane crash</name>
          <styleUrl>#fireicon</styleUrl>
          <description><![CDATA[Plane crash in N Akron Rd
Mountain View, CA 94043]]></description>
          <Point>
            <coordinates>37.411346,-122.059608,0.000000</coordinates>
          </Point>
        </Placemark>

        <Placemark>
          <name>Fire in Park</name>
          <styleUrl>#fireicon</styleUrl>
          <description><![CDATA[fire in Berry Dr
Mountain View, CA 94043
]]></description>
          <Point>
            <coordinates>37.40971,-122.061796,0.000000</coordinates>
          </Point>
        </Placemark>

        <Placemark>
          <name>Fire in building 23</name>
          <styleUrl>#fireicon</styleUrl>
          <description><![CDATA[test]]></description>
          <Point>
            <coordinates>37.410153,-122.059286,0.000000</coordinates>
          </Point>
        </Placemark>

        <Placemark>
          <name>Earthquake</name>
          <styleUrl>#fireicon</styleUrl>
          <description><![CDATA[Earthquake in Mc Cord Ave
Mountain View, CA 94043
]]></description>
          <Point>
            <coordinates>37.411073,-122.056947,0.000000</coordinates>
          </Point>
        </Placemark>

        <Placemark>
          <name>San Bruno Fire</name>
          <styleUrl>#fireicon</styleUrl>
          <description><![CDATA[An explosion and fireball erupted from near the intersection near Glenview Drive and Earl Avenue. People as far as one-half mile away say they felt the boom and heat of the explosion.]]></description>
          <Point>
            <coordinates>37.622798,-122.441812,0.000000</coordinates>
          </Point>
        </Placemark>

        <Placemark>
          <name>Fire in Claremont Dr</name>
          <styleUrl>#fireicon</styleUrl>
          <description><![CDATA[1710 Claremont Dr
San Bruno, CA 94066]]></description>
          <Point>
            <coordinates>37.623036,-122.442412,0.000000</coordinates>
          </Point>
        </Placemark>

        <Placemark>
          <name>House on fire</name>
          <styleUrl>#fireicon</styleUrl>
          <description><![CDATA[1661 Claremont Dr
San Bruno, CA 94066]]></description>
          <Point>
            <coordinates>37.623257,-122.441018,0.000000</coordinates>
          </Point>
        </Placemark>

        <Placemark>
          <name>Injury in Earl Ave</name>
          <styleUrl>#fireicon</styleUrl>
          <description><![CDATA[People need help in 1711 Earl Ave
San Bruno, CA 94066]]></description>
          <Point>
            <coordinates>37.622747,-122.442155,0.000000</coordinates>
          </Point>
        </Placemark>

        <Placemark>
          <name>Primary Evacuation Center for fire</name>
          <styleUrl>#fireicon</styleUrl>
          <description><![CDATA[Primary Evacuation Center for fire
Bayhill Shopping Center
San Bruno, CA 94066]]></description>
          <Point>
            <coordinates>37.626435,-122.425804,0.000000</coordinates>
          </Point>
        </Placemark>

        <Placemark>
          <name>Red Cross</name>
          <styleUrl>#fireicon</styleUrl>
          <description><![CDATA[HELP: Veterans Memorial Recreation Center and Senior Center


The American Red Cross Bay Area Chapter disaster action team is on the scene in San Bruno responding to a fire that has engulfed dozens of homes.

 (650) 616-7180 call if you are safe - only if you are in the affected area - they are making a list]]></description>
          <Point>
            <coordinates>37.617359,-122.415075,0.000000</coordinates>
          </Point>
        </Placemark>

        <Placemark>
          <name>House on fire</name>
          <styleUrl>#fireicon</styleUrl>
          <description><![CDATA[1000-1136 Fairmont Dr
San Bruno, CA 94066]]></description>
          <Point>
            <coordinates>37.624123,-122.441361,0.000000</coordinates>
          </Point>
        </Placemark>

        <Placemark>
          <name>New Entity From Android App</name>
          <styleUrl>#fireicon</styleUrl>
          <description><![CDATA[Just test the functionality]]></description>
          <Point>
            <coordinates>37.623781,-122.443036,0.000000</coordinates>
          </Point>
        </Placemark>

        <Placemark>
          <name>Fire</name>
          <styleUrl>#landslide</styleUrl>
          <description><![CDATA[Fire inbayshore sunnyvale golf course Mountain ViewCA 94043]]></description>
          <Point>
            <coordinates>37.405483,-122.094326,0.000000</coordinates>
          </Point>
        </Placemark>

      </Document>
    </kml>
    }
    render :text => test
  end

end
