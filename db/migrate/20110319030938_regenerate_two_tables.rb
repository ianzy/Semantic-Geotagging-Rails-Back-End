class RegenerateTwoTables < ActiveRecord::Migration
  def self.up
    drop_table :comment_categories_entities
    drop_table :comments_response_categories

    create_table :comment_categories_entities do |t|
      t.integer :comment_category_id
      t.integer :entity_id
      t.integer :counter
      t.boolean :important_tag, :default=>false
    end

    add_index :comment_categories_entities, [:entity_id, :comment_category_id], :unique => true
    add_index :comment_categories_entities, :comment_category_id, :unique => false

    create_table :comments_response_categories do |t|
      t.integer :comment_id
      t.integer :response_category_id
      t.integer :counter
      t.boolean :important_tag, :default=>false
    end

    add_index :comments_response_categories, [:comment_id, :response_category_id], :unique => true
    add_index :comments_response_categories, :response_category_id, :unique => false
  end

  def self.down
    drop_table :comment_categories_entities
    drop_table :comments_response_categories

    create_table :comment_categories_entities, :id=>false do |t|
      t.integer :comment_category_id
      t.integer :entity_id
      t.integer :counter
      t.boolean :important_tag, :default=>false
    end

    add_index :comment_categories_entities, [:entity_id, :comment_category_id], :unique => true
    add_index :comment_categories_entities, :comment_category_id, :unique => false

    create_table :comments_response_categories, :id=>false do |t|
      t.integer :comment_id
      t.integer :response_category_id
      t.integer :counter
      t.boolean :important_tag, :default=>false
    end

    add_index :comments_response_categories, [:comment_id, :response_category_id], :unique => true
    add_index :comments_response_categories, :response_category_id, :unique => false
  end
end
