Thot::Application.routes.draw do

  # ---------------------------------------------------------- for library users
  resources :books, :only => [:index, :show]
  resources :items, :only=>[:show]
  resources :loans, :only => [:create, :destroy]
  resources :publishers, :only => [:show]
  resources :searches
  resources :shelves, :only => [:show]

  # devise_for :users
  resources :users, :only => [:show]
  namespace :nebis do
    get 'extend'
  end
  resources :nebis, :only => [:show]

  # -------------------------------------------- for Operators and Administrator
  devise_for :admins
  namespace :adm do
    resources :admins
    resources :books, :only => [:new, :edit, :create, :update, :destroy] do
      get :autocomplete_publisher_name, :on => :collection
      resources :items, :only=>[:new, :create]
    end
    resources :deg_isbns
    resources :goods
    resources :inventory_sessions do
      resources :shelves, :only => [:show]
      post :check
      get  :commit_moves
      get  :commit_missings
    end
    match 'inventory_sessions/inventorize_search', :to => 'inventory_sessions#inventorize_search', :via => :post, :as => 'inventorize_search'
    resources :items, :only=>[:index, :show, :edit, :update, :destroy]
    resources :labs
    resources :locations do
      resources :shelves, :only=>[:new, :create, :index]
    end
    resources :publishers, :only => [:index, :new, :edit, :create, :update, :destroy]
    resources :publisher_mergers, :only=>[:new, :create, :update]
    resources :shelves, :only => [:index, :show, :update, :destroy]
    resources :users do
      # get :autocomplete_location_name, :on => :collection
    end
  end

  match 'admin/cpanel', :to => 'home#admin', :via => :get, :as => 'cpanel'
  match 'stats', :to => 'home#stats', :via => :get, :as => 'stats'

  root :to => "searches#new"

  # ----------------------------------------------------------------------------
  # authenticated :user do
  #   root :to => "searches#new"
  # end

  # match '/items/:inv/toggle' => 'items#toggle', :as => 'toggle_item'

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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
