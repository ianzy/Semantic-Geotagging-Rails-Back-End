class AddNameToResponseCounterTable < ActiveRecord::Migration
  def self.up
    add_column :comments_response_categories, :response_category_name, :string
  end

  def self.down
    remove_column :comments_response_categories, :response_category_name
  end
end
