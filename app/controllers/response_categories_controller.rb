class ResponseCategoriesController < ApplicationController
  # GET /response_categories
  # GET /response_categories.xml
  def index
    @response_categories = ResponseCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @response_categories }
    end
  end

  # GET /response_categories/1
  # GET /response_categories/1.xml
  def show
    @response_category = ResponseCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @response_category }
    end
  end

  # GET /response_categories/new
  # GET /response_categories/new.xml
  def new
    @response_category = ResponseCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @response_category }
    end
  end

  # GET /response_categories/1/edit
  def edit
    @response_category = ResponseCategory.find(params[:id])
  end

  # POST /response_categories
  # POST /response_categories.xml
  def create
    @response_category = ResponseCategory.new(params[:response_category])

    respond_to do |format|
      if @response_category.save
        format.html { redirect_to(@response_category, :notice => 'ResponseCategory was successfully created.') }
        format.xml  { render :xml => @response_category, :status => :created, :location => @response_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @response_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /response_categories/1
  # PUT /response_categories/1.xml
  def update
    @response_category = ResponseCategory.find(params[:id])

    respond_to do |format|
      if @response_category.update_attributes(params[:response_category])
        format.html { redirect_to(@response_category, :notice => 'ResponseCategory was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @response_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /response_categories/1
  # DELETE /response_categories/1.xml
  def destroy
    @response_category = ResponseCategory.find(params[:id])
    @response_category.destroy

    respond_to do |format|
      format.html { redirect_to(response_categories_url) }
      format.xml  { head :ok }
    end
  end
end
