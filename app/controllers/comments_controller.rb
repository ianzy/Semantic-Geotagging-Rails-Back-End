class CommentsController < ApplicationController

  before_filter :require_user
  # GET /comments
  # GET /comments.xml
  def index
    if params[:entity_id].nil? || params[:category_id].nil?
      @comments = Comment.all 
    else
      session[:comment_id] = nil
      entity = Entity.find(params[:entity_id])
      session[:entity_id] = params[:entity_id]
      session[:category_id] = category_id = params[:category_id]
      @category = CommentCategory.find(category_id)
      @comments = entity.comments.find_all_by_category_id category_id, :order=> 'created_at DESC'
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
      format.json { render :json => @comments }
    end
  end

  def responses
    comment = Comment.find params[:comment_id]
    session[:comment_id] = params[:comment_id]
    session[:category_id] = category_id = params[:category_id]
    @category = ResponseCategory.find(category_id)
    @responses = comment.comments.find_all_by_category_id category_id, :order=> 'created_at DESC'

    respond_to do |format|
      format.html
      format.xml  { render :xml => @responses }
      format.json { render :json => @responses }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])
    @categories = CommentCategoryCounter.find_all_by_comment_id @comment,
      :order=>"response_category_name ASC"
    
    if @categories.empty?
        categories = ResponseCategory.find :all, :order=> 'created_at'
        categories.each do |category|
          CommentCategoryCounter.create(
          :response_category_id => category.id,
          :comment_id => @comment.id,
          :counter => 0,
          :important_tag => false,
          :response_category_name => category.name)
        end
        @categories = CommentCategoryCounter.find_all_by_comment_id @comment, :order=>"response_category_name ASC"
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new
    @comment.user_id = current_user.id
    if session[:comment_id]
      @comment.comment_id = session[:comment_id]
      @comment.entity_id = -1
    else
      @comment.entity_id = session[:entity_id]
      @comment.comment_id = -1
    end
    
    @comment.category_id = session[:category_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    puts "1111111111111111111111111111"
    p params[:comment]
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        session[:entity_id] = nil
        session[:category_id] = nil
        session[:comment_id] = nil
        format.html { redirect_to(@comment, :notice => 'Comment was successfully created.') }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(@comment, :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end
end
