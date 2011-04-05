class Entity < ActiveRecord::Base
  has_many :comments
  has_many :resps
#  validates_presence_of :title
end
