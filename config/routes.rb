ActionController::Routing::Routes.draw do |map|

  #map.connect "/mapview", :controller=>"mapview"
  # Routes for api controller
  # this set of routes are used for the resources providing to the
  # android application
  map.apientities "api/entities.:format",
    :conditions => { :method => :get},
    :controller => "api",
    :action => "get_entities"
  map.apicomments "api/comments.:format",
    :conditions => { :method => :get},
    :controller => "api",
    :action => "get_comments"
  map.apicommentcategories "api/comment_categories.:format",
    :conditions => { :method => :get},
    :controller => "api",
    :action => "get_comment_categories"
  map.apiresponses "api/responses.:format",
    :conditions => { :method => :get},
    :controller => "api",
    :action => "get_responses"
  map.apiresponsecategories "api/response_categories.:format",
    :conditions => { :method => :get},
    :controller => "api",
    :action => "get_response_categories"
  map.apicreateentity "api/entities.:format",
    :conditions => { :method => :post},
    :controller => "api",
    :action => "create_entity"
  map.apicreatecomment "api/comments.:format",
    :conditions => { :method => :post},
    :controller => "api",
    :action => "create_comment"
  # end of the api routes
  
  map.clear_database "data_management/delete_all",
    :conditions => { :method => :delete},
    :controller => "data_management", 
    :action => "delete_all"
  
  map.restore_database   "data_management/restore",
    :conditions => { :method => :get},
    :controller => "data_management", 
    :action => "restore"
  
  map.categories "pages/categories",
    :conditions => { :method => :get},
    :controller => "pages", 
    :action => "categories"
    
  map.data_management "pages/data_management",
    :conditions => { :method => :get},
    :controller => "pages", 
    :action => "data_management"
    
  map.mapview "mapview",
    :conditions => { :method => :get},
    :controller => "mapview", 
    :action => "index"
  map.resource :user_session
  map.root :controller => "entities", :action => "index" # optional, this just sets the root route

  map.resource :account, :controller => "users"
  map.resources :users

  map.resources :response_categories

  map.resources :comment_categories

  #map.resources :products, :member => { :detailed => :get }
  map.resources :comments do |comments|
    comments.responses 'responses',
      :controller=>'comments', :action=>'responses'
  end

  map.resources :icons

  map.resources :resps

  map.resources :responses

  map.resources :entities do |entities|
    entities.resources :comments
  end

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action.:format'
end
