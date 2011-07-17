class DataManagementController < ApplicationController
  before_filter :require_admin
  def restore
    
  end
  
  def delete_all
    interesting_tables.each do |tbl|
      next if tbl.nil?
      tbl = "EntityCategoryCounter" if tbl == "comment_categories_entities"
      tbl = "CommentCategoryCounter" if tbl == "comments_response_categories" 
      klass = tbl.classify.constantize
      puts "Deleting #{tbl}..."
      klass.delete_all
    end
    
    redirect_to(root_path)
  end
  
  private 
  def interesting_tables
    tables = ActiveRecord::Base.connection.tables.sort
    tables.delete("schema_migrations")
    tables.delete("users")
    tables
  end
end
