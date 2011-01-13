class AddCurrentEntityIdColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :current_entity_time, :datetime,
      :null => false, :default => '2010-10-08T07:59:46Z'
  end

  def self.down
    remove_column :users, :current_entity_time
  end
end
