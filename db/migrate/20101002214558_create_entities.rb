class CreateEntities < ActiveRecord::Migration
  def self.up
    create_table :entities do |t|
      t.string :title
      t.text :description
      t.string :icon_uri
      t.string :location
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end

  def self.down
    drop_table :entities
  end
end
