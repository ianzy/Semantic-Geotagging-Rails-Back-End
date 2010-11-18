class CreateCommentCategories < ActiveRecord::Migration
  def self.up
    create_table :comment_categories do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :comment_categories
  end
end
