class AddImportantTagForComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :important_tag, :boolean, :default => 0
  end

  def self.down
    remove_column :comments, :important_tag
  end
end
