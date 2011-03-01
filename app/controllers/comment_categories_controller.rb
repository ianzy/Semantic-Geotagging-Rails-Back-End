class CommentCategoriesController < ApplicationController
  # GET /comment_categories
  # GET /comment_categories.xml
  def index
    @comment_categories = CommentCategory.find :all, :order=> 'created_at'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comment_categories }
    end
  end

  # GET /comment_categories/1
  # GET /comment_categories/1.xml
  def show
    @comment_category = CommentCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment_category }
    end
  end

  # GET /comment_categories/new
  # GET /comment_categories/new.xml
  def new
    @comment_category = CommentCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment_category }
    end
  end

  # GET /comment_categories/1/edit
  def edit
    @comment_category = CommentCategory.find(params[:id])
  end

  # POST /comment_categories
  # POST /comment_categories.xml
  def create
    @comment_category = CommentCategory.new(params[:comment_category])

    respond_to do |format|
      if @comment_category.save
        format.html { redirect_to(@comment_category, :notice => 'CommentCategory was successfully created.') }
        format.xml  { render :xml => @comment_category, :status => :created, :location => @comment_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comment_categories/1
  # PUT /comment_categories/1.xml
  def update
    @comment_category = CommentCategory.find(params[:id])

    respond_to do |format|
      if @comment_category.update_attributes(params[:comment_category])
        format.html { redirect_to(@comment_category, :notice => 'CommentCategory was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comment_categories/1
  # DELETE /comment_categories/1.xml
  def destroy
    @comment_category = CommentCategory.find(params[:id])
    @comment_category.destroy

    respond_to do |format|
      format.html { redirect_to(comment_categories_url) }
      format.xml  { head :ok }
    end
  end
end
