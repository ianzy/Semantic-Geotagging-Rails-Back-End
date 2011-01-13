require 'base64'

class RespsController < ApplicationController

  before_filter :require_user

  # GET /resps
  # GET /resps.xml
  def index
    @resps = Resp.find_all_by_entity_id  params[:entity_id], :limit=>10

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resps }
      format.json { render :json => @resps }
    end
  end

  # GET /resps/1
  # GET /resps/1.xml
  def show
    @resp = Resp.find(params[:id])
    

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @resp }
    end
  end

  # GET /resps/new
  # GET /resps/new.xml
  def new
    @resp = Resp.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resp }
    end
  end

  # GET /resps/1/edit
  def edit
    @resp = Resp.find(params[:id])
  end

  # POST /resps
  # POST /resps.xml
  def create
    @resp = Resp.new(params[:resp])

    respond_to do |format|
      if @resp.save
        format.html { redirect_to(@resp, :notice => 'Resp was successfully created.') }
        format.xml  { render :xml => @resp, :status => :created, :location => @resp }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @resp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /resps/1
  # PUT /resps/1.xml
  def update
    @resp = Resp.find(params[:id])

    respond_to do |format|
      if @resp.update_attributes(params[:resp])
        format.html { redirect_to(@resp, :notice => 'Resp was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @resp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /resps/1
  # DELETE /resps/1.xml
  def destroy
    @resp = Resp.find(params[:id])
    @resp.destroy

    respond_to do |format|
      format.html { redirect_to(resps_url) }
      format.xml  { head :ok }
    end
  end
  
end
