Traveler::Application.routes.draw do
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

  # match "trip_segments/ordered" => "trip_segments#index_ordered_by_origin", :as => :order_by_origin_trip_segments   # <<<< can this be done better?

  # match "trip_segments/destination/orderby" => "trip_segments#order_by_distance_destination", :as => :order_by_distance_destination, :via => :get

  match "trip_segments/order_by_distance/:destination", :to => "trip_segments#order_by_distance", :as => :order_by_destination_distance
  match "trip_segments/destination/:destination" => "trip_segments#limit_by_destination", :as => :destination, :via => :get       # , :contraints => { :destination => /^[a-zA-Z0-9]*$/}
  match "trip_segments/index_by_trip/:trip_id" => "trip_segments#index_by_trip", :as => :all_segments_for_trip, :via => :get
  match "trip_segments/search" => "trip_segments#search", :via => :get

  resources :trip_segments do
    get :index_ordered_by_origin, :as => :order_by_origin, :on => :collection
  end

  resources :trips do
    get :index_all, :on => :collection
  end

  resources :locales, :only => "index"       # <<< limit it to index for now.

  # *** Try screwing aorund with this ***
  # match "trip_segments/vacation_spot/:destination" => redirect("trip_segments/destination/:destination")


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
  # root :to => "welcome#index"

  root :to => "trips#index"


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
