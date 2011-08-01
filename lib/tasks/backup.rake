# http://blog.leetsoft.com/2006/5/29/easy-migration-between-databases
namespace :db do
  namespace :backup do
    def interesting_tables
      tables = ActiveRecord::Base.connection.tables.sort
      tables.delete("schema_migrations")
      tables
    end
    
    desc "Dump entire db."
    task :write => :environment do 

      dir = RAILS_ROOT + '/db/backup'
      FileUtils.mkdir_p(dir)
      FileUtils.chdir(dir)
    
    
      interesting_tables.each do |tbl|
        next if tbl.nil?
        tbl = "EntityCategoryCounter" if tbl == "comment_categories_entities"
        tbl = "CommentCategoryCounter" if tbl == "comments_response_categories" 
        klass = tbl.classify.constantize
        tbl = "comment_categories_entities" if tbl == "EntityCategoryCounter"
        tbl = "comments_response_categories" if tbl == "CommentCategoryCounter"
        
        puts "Writing #{tbl}..."
        File.open("#{tbl}.yml", 'w+') { |f| YAML.dump klass.find(:all).collect(&:attributes), f }      
      end
    
    end
  
    task :read => [:environment, 'db:schema:load'] do 
      dir = RAILS_ROOT + '/db/backup'
      FileUtils.mkdir_p(dir)
      FileUtils.chdir(dir)
    
      interesting_tables.each do |tbl|
        tbl = "EntityCategoryCounter" if tbl == "comment_categories_entities"
        tbl = "CommentCategoryCounter" if tbl == "comments_response_categories"
        klass = tbl.classify.constantize
        klass.delete_all
        tbl = "comment_categories_entities" if tbl == "EntityCategoryCounter"
        tbl = "comments_response_categories" if tbl == "CommentCategoryCounter"
        
        ActiveRecord::Base.transaction do 
        
          puts "Loading #{tbl}..."
          YAML.load_file("#{tbl}.yml").each do |fixture|
            ActiveRecord::Base.connection.execute "INSERT INTO #{tbl} (#{fixture.keys.join(",")}) VALUES (#{fixture.values.collect { |value| ActiveRecord::Base.connection.quote(value) }.join(",")})", 'Fixture Insert'
          end        
        end
      end
    end
  end
end
