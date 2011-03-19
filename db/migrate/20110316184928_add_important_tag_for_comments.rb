class AddImportantTagForComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :important_tag, :boolean, :default => false
  end

  def self.down
    remove_column :comments, :important_tag
  end
end
