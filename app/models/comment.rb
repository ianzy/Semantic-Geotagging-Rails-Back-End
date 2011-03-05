class Comment < ActiveRecord::Base
  has_many :comments
  
  after_create  :increment_counter_cache
  after_destroy :decrement_counter_cache

  private
  def decrement_counter_cache
    Comment.decrement_counter("comments_counter", comment_id)
  end

  def increment_counter_cache
    Comment.increment_counter("comments_counter", comment_id)
  end
end
