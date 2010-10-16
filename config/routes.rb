ActionController::Routing::Routes.draw do |map|
  Typus::Routes.draw(map)
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
  map.masters 'masters', :controller => :users, :action => :masters
  map.edit_profile 'profile/edit', :controller => :users, :action => :edit_profile
  map.change_status 'change_status', :controller => :users, :action => :change_status
  map.profile 'profile/:id', :controller => :users, :action => :profile
  map.my_events 'events/my/:page', :controller => :events, :action => :my, :page => 1
  map.resources :events, :collection => { :cities => :get, :subjects => :get, :search => :get, :subjects2 => :get }, :member => { :destroy => :get }
  map.root :controller => :news, :action => :index
  map.post '/news/:id', :controller => :news, :action => :show
  map.register 'register', :controller => 'users', :action => 'register'
  map.login 'login', :controller => "users", :action => 'login'
  map.logout 'logout', :controller => 'users', :action => 'logout'
  map.forgot_password 'forgot_password', :controller => 'users', :action => "forgot_password"
  map.change 'change_password', :controller => 'users', :action => "change_password"
  map.faq 'faq', :controller => 'common', :action => 'faq'
  map.materials 'materials', :controller => 'common', :action => 'materials'
  map.material 'material/:id', :controller => 'common', :action => "show_material"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
