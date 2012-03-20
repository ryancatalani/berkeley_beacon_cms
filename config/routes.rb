BeaconApp::Application.routes.draw do
	get "admin/home"
	controller :people do 
		match "/staff/:name", :to => :show
	end
	
	match '/stylebook', :to => 'stylebook_entries#index'
	match '/tips', :to => 'pages#tips'
	match '/send_tip', :to => 'pages#send_tip', :via => :post
	match '/new_media_person', :to => 'people#new_media_person', :via => :post
	match '/new_tag/:tag_id/article/:article_id', :to => 'taggings#new_tagging', :via => :post
  match '/oscars', :to => 'pages#oscars'

  match '/ecla', :to => 'pages#ecla'
  match '/emersonla', :to => 'pages#ecla'
  
  match '/emersonla_live', :to => 'pages#emersonla_live'
  match '/emersonla-live', :to => 'pages#emersonla_live'
  match '/beacon_ecla_tweets', :to => 'pages#beacon_ecla_tweets'
  match '/all_ecla_tweets', :to => 'pages#all_ecla_tweets'
  match '/archive_problem/:url', :to => 'pages#archive_problem', :via => :post

  match '/ourvoice', :to => 'pages#ourvoice'
  match '/ournewvoice', :to => 'pages#ourvoice'
  match '/redesign', :to => 'pages#ourvoice'

	resources :stylebook_entries, :except => [:show]
	resources :series, :only => [:new, :create, :edit, :update, :index]
	resources :people
	resources :articles, :only => [:new, :create, :edit, :update, :destroy, :index]
	resources :sessions, :only => [:new, :create, :destroy]
	resources :mediafiles
	# resources :sections, :only => [:show]	
	match '/login', :to => 'sessions#new'
	match '/logout', :to => 'sessions#destroy'
	match '/about', :to => 'pages#about'
	root :to => 'pages#home'
	controller :articles do
		scope ":sectionname" do
			scope ":year" do
				scope ":month" do
					scope ":day" do
						match ":title", :to => :show, :as => :getselectedarticle
					end
				end
			end
		end
	end
		
	controller :sections do
		match ":name", :to => :show
	end
	
	
	
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
