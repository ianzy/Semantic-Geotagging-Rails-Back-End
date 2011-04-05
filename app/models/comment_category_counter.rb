# To change this template, choose Tools | Templates
# and open the template in the editor.

class CommentCategoryCounter < ActiveRecord::Base
  set_table_name 'comments_response_categories'
  belongs_to :response_category
end
