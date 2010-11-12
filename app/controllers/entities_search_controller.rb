class EntitiesSearchController < ApplicationController
  in_place_edit_for :entity, :title

  #open class on the fly
  #get the instance variable in the view
  class ActionView::Base
      def get_entity
        @entity
      end
  end

  def index
    @entities = Entity.find :all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entities }
      format.json { render :json => @entities }
    end

    #print the instance variable in the view
    puts @template.get_entity.to_s
    ent = @template.get_entity
    puts "#{ent.title} #{ent.description} #{ent.lat} #{ent.lng}"

  end

  def search
    unless params[:search].blank?
      @entities = Entity.find :all, :conditions => ["description like ?", "%"+params[:search]+"%"]
      if @entities
        render :partial=>'search', :layout=>false
      else
        @entities = Entity.all
        render :partial=>'search'
      end
    else
      @entities = Entity.all
      render :partial=>'search'
    end
    
  end

  # GET /entities/1
  # GET /entities/1.xml
  def show
    @entity = Entity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entity }
    end
  end

  # PUT /entities/1
  # PUT /entities/1.xml
  def update
    @entity = Entity.find(params[:id])

    respond_to do |format|
      if @entity.update_attributes(params[:entity])
        format.html { redirect_to(@entity, :notice => 'Entity was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entity.errors, :status => :unprocessable_entity }
      end
    end
  end

  def form_inside_form_test
    puts "Inside form_inside_form_test"
    @entity = Entity.new
  end

  def ajax_method_for_form
    puts "Inside ajax_method_for_form"
    puts params[:entity_lat].to_s
    puts params[:entity_lng].to_s
  end

  def create_for_form
    puts "Inside create_for_form"
  end
end
