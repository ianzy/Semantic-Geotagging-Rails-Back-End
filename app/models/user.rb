class User < ActiveRecord::Base
  acts_as_authentic
  has_many :comments
  
  attr_accessible :login, :email, :user_image, :password, :password_confirmation
end
