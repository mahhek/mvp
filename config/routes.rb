ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  map.resource :user_session,:collection => [:create => :get]
  map.resources :users, :collection  => {:update_password => :post }
  map.update_location_status "/location/update/status/:id", :controller => "locations", :action => "update_location_status"
  map.update_start_date "/location/update/start_date/:id", :controller => "locations", :action => "update_start_date"
  
  map.resources :locations do |location|
    location.resources :avatars
    location.resources :payments
  end
  map.search_location "/spaces/search_location", :controller => 'locations', :action => 'search_location'

  map.resources :accounts
  map.amount_withdraw "/account/:id/withdraw", :controller => "accounts", :action => "withdraw_amount"


  map.user_create "/user/create", :controller => 'users', :action => 'create'
  map.user_session_create "/login/create", :controller => 'user_sessions', :action => 'create'
  map.signup 'signup', :controller => 'users', :action => 'new'
  map.new_signup '/user/signup', :controller => 'users', :action => 'new_signup'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.new_create '/user/create', :controller => 'users', :action => 'new_create'
  map.homepage '/homepage', :controller => "welcome", :action => "homepage"
  map.requested_city '/new/requested_city', :controller => "welcome", :action => "new_requested_city"
  
  map.activate_account '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.send_activation 'send_activation(/:user_id)' , :controller => 'users', :action => 'send_activation'
  map.forgot_password 'forgot_password', :controller => 'user_sessions', :action => 'forgot_password'
  #  get
  map.forgot_password_submit 'forgot_password_submit', :controller => 'user_sessions' , :action => 'forgot_password_lookup_email'
  # post

  map.reset_password_submit 'reset_password_submit/:reset_password_code' , :controller => 'users', :action => 'reset_password_submit'
  map.reset_password 'reset_password/:reset_password_code' , :controller => 'users', :action => 'reset_password'

  map.root :controller => "welcome", :action => "index"

  map.namespace :xml do |ns|
    ns.connect 'location_search.xml',
      :controller => 'LocationSearch',
      :action => 'index',
      :format => :xml
    ns.connect 'location_timezone_search.xml',
      :controller => 'LocationTimezoneSearch',
      :action => 'index',
      :format => :xml
    ns.connect 'address_search.xml',
      :controller => 'AddressSearch',
      :action => 'index',
      :format => :xml
  end


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
end
