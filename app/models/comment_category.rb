class CommentCategory < ActiveRecord::Base
  has_many :entity_category_counters
end
