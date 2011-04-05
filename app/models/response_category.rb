class ResponseCategory < ActiveRecord::Base
  has_many :comment_category_counters
end
