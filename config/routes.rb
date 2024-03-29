VideoContest::Application.routes.draw do
  
  # get "votes/new"
  # get "shares/new"
  # get "plays/new"
  get "messages/new"
  get "password_resets/new"
  get "videos/new"

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets
  resources :videos
  resources :messages, only: [:new, :create]
  resources :plays, only: :create
  resources :shares, only: :create
  resources :votes, only: :create
  
  root to: 'static_pages#home'
  
  match "/panda/authorize_upload", :to => "panda#authorize_upload"
  
  match '/addvideo',          to: 'videos#addvideo'
  match '/newvideo',          to: 'videos#new'
  match '/av',                to: 'videos#index'
  match '/watch',             to: 'videos#watch'
  
  match '/rated',             to: 'videos#rated'
  match '/votes',             to: 'videos#votes'
  match '/shares',            to: 'videos#shares'
  match '/views',             to: 'videos#views'
  match '/search',            to: 'videos#search'
  
  match '/signin',            to: 'sessions#new'
  match '/signout',           to: 'sessions#destroy', via: :delete
  
  match '/register',          to: 'users#new'
  match '/u',                 to: 'users#index'
  match '/users',             to: 'users#index'
  match '/u/:id',             to: 'users#show'
  match '/myvideos',          to: 'users#videos'
  match '/mv',                to: 'users#videos'
  match '/myassets',          to: 'users#assets'
  match '/contributors',      to: 'users#contributors'
  
  match '/faq',               to: 'static_pages#faq'
  match '/terms',             to: 'static_pages#terms'
  match '/privacy',           to: 'static_pages#privacy'
  match '/rules',             to: 'static_pages#rules'
  match '/information',       to: 'static_pages#information'
  match '/statistics',        to: 'static_pages#statistics'
  match '/contact',           to: 'messages#new'
  
  # Any routes that aren't defined above here go to the 404
  match "*a",                 to: "application#routing_error"
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
