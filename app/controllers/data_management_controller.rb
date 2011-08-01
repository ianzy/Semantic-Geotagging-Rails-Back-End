class DataManagementController < ApplicationController
  before_filter :require_admin
  def restore
    # dir = RAILS_ROOT + '/db/backup'
    # FileUtils.mkdir_p(dir)
    # FileUtils.chdir(dir)
    tables = ActiveRecord::Base.connection.tables.sort
    tables.delete("schema_migrations")
    tables.each do |tbl|
      tbl = "EntityCategoryCounter" if tbl == "comment_categories_entities"
      tbl = "CommentCategoryCounter" if tbl == "comments_response_categories"
      klass = tbl.classify.constantize
      klass.delete_all
      tbl = "comment_categories_entities" if tbl == "EntityCategoryCounter"
      tbl = "comments_response_categories" if tbl == "CommentCategoryCounter"
      
      ActiveRecord::Base.transaction do 
      
        puts "Loading #{tbl}..."
        YAML.load_file("#{RAILS_ROOT}/db/backup/#{tbl}.yml").each do |fixture|
          ActiveRecord::Base.connection.execute "INSERT INTO #{tbl} (#{fixture.keys.join(",")}) VALUES (#{fixture.values.collect { |value| ActiveRecord::Base.connection.quote(value) }.join(",")})", 'Fixture Insert'
        end        
      end
    end
    
    redirect_to(root_path)
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
