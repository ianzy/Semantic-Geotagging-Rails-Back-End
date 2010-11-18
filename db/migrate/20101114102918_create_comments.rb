class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :user_id
      t.integer :entity_id
      t.integer :category_id
      t.string :image_url
      t.integer :comment_id
      t.string :type
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
