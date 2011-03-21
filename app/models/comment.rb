class Comment < ActiveRecord::Base
  has_many :comments
  
  after_create  :increment_counter_cache
  after_destroy :decrement_counter_cache

  private
  def decrement_counter_cache
    Comment.decrement_counter("comments_counter", comment_id)
    if self.entity_id != -1
      @counter = EntityCategoryCounter.find_by_entity_id_and_comment_category_id self.entity_id, self.category_id
      counts = @counter.counter - 1
      result = Comment.count ["important_tag = 1 and entity_id = ?", self.entity_id]
      important_tag_for_category = @counter.important_tag
      important_tag_for_category = false if result == 0
      @counter.update_attributes(:counter=>counts, :important_tag=>important_tag_for_category)
    else
      @counter = CommentCategoryCounter.find_by_comment_id_and_response_category_id self.comment_id, self.category_id
      counts = @counter.counter - 1
      result = Comment.count ["important_tag = 1 and entity_id = ?", self.entity_id]
      important_tag_for_category = @counter.important_tag
      important_tag_for_category = false if result == 0
      @counter.update_attributes(:counter=>counts, :important_tag=>important_tag_for_category)
    end
  end

  def increment_counter_cache
    Comment.increment_counter("comments_counter", comment_id)

    if self.entity_id != -1
      @counter = EntityCategoryCounter.find_by_entity_id_and_comment_category_id self.entity_id, self.category_id
      if nil == @counter
        categories = CommentCategory.find :all, :order=> 'created_at'
        categories.each do |category|
          EntityCategoryCounter.create(
          :comment_category_id => category.id,
          :entity_id => self.entity_id,
          :counter => 0,
          :important_tag => false)
        end
        @counter = EntityCategoryCounter.find_by_entity_id_and_comment_category_id self.entity_id, self.category_id
      end

      counts = @counter.counter + 1
      important_tag_for_category = @counter.important_tag
      important_tag_for_category = true if self.important_tag == true
      @counter.update_attributes(:counter=>counts, :important_tag=>important_tag_for_category)

    else
      @counter = CommentCategoryCounter.find_by_comment_id_and_response_category_id self.comment_id, self.category_id
      if nil == @counter
        categories = ResponseCategory.find :all, :order=> 'created_at'
        categories.each do |category|
          CommentCategoryCounter.create(
          :response_category_id => category.id,
          :comment_id => self.comment_id,
          :counter => 0,
          :important_tag => false)
        end
        @counter = CommentCategoryCounter.find_by_comment_id_and_response_category_id self.comment_id, self.category_id
      end

      counts = @counter.counter + 1
      important_tag_for_category = @counter.important_tag
      important_tag_for_category = true if self.important_tag == true
      @counter.update_attributes(:counter=>counts, :important_tag=>important_tag_for_category)
    end
  end
end
