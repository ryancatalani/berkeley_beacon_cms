BeaconApp::Application.routes.draw do

	get "admin/home"
	controller :people do 
		match "/staff/:name", :to => :show
	end
	
  match '/search', :to => 'pages#search', :as => 'search', :via => :post
  match '/search_edit', :to => 'articles#search_edit', :as => 'search_edit', :via => :post

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

  match '/apply', :to => 'pages#apply'

  match '/settings', :to => 'people#settings'
  match '/videos', :to => 'pages#videos'

	resources :stylebook_entries, :except => [:show]
	resources :series, :only => [:new, :create, :edit, :update, :index]
	resources :people
	resources :articles, :only => [:new, :create, :edit, :update, :destroy, :index]
	resources :sessions, :only => [:new, :create, :destroy]
	resources :mediafiles
  resources :blogs, :only => [:new, :create, :edit, :update, :index]

  match '/new_editorial_cartoon', :to => 'pages#new_editorial_cartoon'
  match '/opinion/editorial_cartoons', :to => 'pages#editorial_cartoons'

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
	
  match "/arts-and-entertainment" => redirect("/arts")
	controller :sections do
		match ":name", :to => :show
	end
  controller :blogs do
    match "/blogs/:name", :to => :show
  end	

  match '/go/police' => redirect("http://www.berkeleybeacon.com/multimedia/2012/9/6/an-interview-with-the-new-police-chief")
  match '/go/scaffolding' => redirect("http://www.berkeleybeacon.com/multimedia/2012/9/6/students-react-to-the-little-building-scaffolding-art")
  match '/go/ols' => redirect("http://www.berkeleybeacon.com/multimedia/2012/9/6/meet-the-orientation-leader-core-staff")
	match '/go/fashion-night-out' => redirect("http://www.berkeleybeacon.com/lifestyle/2012/9/13/fashion-night-out")
  match '/go/print-copy' => redirect("http://www.berkeleybeacon.com/news/2012/9/13/print-and-copy-center-finds-new-home")
  match '/go/leap' => redirect("http://berkeleybeacon.com/lifestyle/2012/9/20/emerson-women-leap-to-teach-selfdefense")
  match '/go/soccer' => redirect("http://www.berkeleybeacon.com/multimedia")
	match '/go/beacon-beat' => redirect("http://www.berkeleybeacon.com/news/2012/10/11/the-beacon-beat-october-11-2012")
  match '/go/magician' => redirect("http://www.berkeleybeacon.com/multimedia/2012/9/27/emerson-mane-events-brings-magic-to-campus")
  match '/go/collegefest' => redirect("http://berkeleybeacon.com/lifestyle/2012/9/27/students-enjoy-swag-and-songs-at-collegefest-2012")
  match '/go/quinnterviews' => redirect("http://www.berkeleybeacon.com/news/2012/10/4/quinnterviews-picked-up-by-mtvu")
  match '/go/sexapalooza' => redirect("http://www.berkeleybeacon.com/lifestyle/2012/10/4/sexapalooza-education-and-lubrication")
  match '/go/womens-soccer' => redirect("http://www.berkeleybeacon.com/sports/2012/10/11/emerson-crucified-by-saints")
  match '/go/lb-maintenance' => redirect("http://www.berkeleybeacon.com/news/2012/10/11/little-building-construction-continues")
  match '/go/cleaning' => redirect("http://berkeleybeacon.com/lifestyle/2012/10/18/christian-students-offer-cleaning-services")
  match '/go/mens-soccer' => redirect("http://berkeleybeacon.com/sports/2012/10/18/determined-defensive-display")

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
