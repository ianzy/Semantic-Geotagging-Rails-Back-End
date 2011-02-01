class AddImageurlToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :user_image, :string,
      :default => 'http://selfsolved.com/images/icons/default_user_icon_128.png'
  end

  def self.down
    remove_column :users, :user_image
  end
end
