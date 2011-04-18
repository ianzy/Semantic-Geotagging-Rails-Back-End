class AddIconNameToEntities < ActiveRecord::Migration
  def self.up
    add_column :entities, :icon_name, :string
  end

  def self.down
    remove_column :entities, :icon_name
  end
end
