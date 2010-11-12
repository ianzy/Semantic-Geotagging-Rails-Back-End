class CreateResps < ActiveRecord::Migration
  def self.up
    create_table :resps do |t|
      t.integer :entity_id
      t.string :username
      t.datetime :time
      t.text :resp
      t.string :lang
      t.string :image
      t.string :source
      t.string :location
      t.float :lat
      t.float :lng


      t.timestamps
    end
  end

  def self.down
    drop_table :resps
  end
end
