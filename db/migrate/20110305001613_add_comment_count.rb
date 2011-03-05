class AddCommentCount < ActiveRecord::Migration
  def self.up
    add_column :comments, :comments_counter, :integer, :default => 0

    Comment.reset_column_information
    Comment.find(:all).each do |p|
      Comment.update_counters p.id, :comments_counter => p.comments.length
    end
  end

  def self.down
    remove_column :comments, :comments_counter
  end
end
