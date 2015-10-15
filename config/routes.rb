BeaconApp::Application.routes.draw do

  get "outbox/weekly_newsletter"

	controller :people do
		match "/staff/:name", :to => :show
	end

  match '/search', to: 'pages#search', as: 'search'
  match '/search_edit', :to => 'articles#search_edit', :as => 'search_edit', :via => :post

	match '/stylebook', :to => 'stylebook_entries#index'
	match '/tips', :to => 'pages#tips'
	match '/send_tip', :to => 'pages#send_tip', :via => :post
	match '/new_media_person', :to => 'people#new_media_person', :via => :post
	match '/new_tag/:tag_id/article/:article_id', :to => 'taggings#new_tagging', :via => :post

  match '/ecla', :to => 'pages#emersonla'
  match '/emersonla', :to => 'pages#emersonla'
  # match '/emersonla-live', :to => 'pages#emersonla_live'
  # match '/beacon_ecla_tweets', :to => 'pages#beacon_ecla_tweets'
  # match '/all_ecla_tweets', :to => 'pages#all_ecla_tweets'

  match '/archive_problem/:url', :to => 'pages#archive_problem', :via => :post

  match '/ourvoice', :to => 'pages#ourvoice'
  match '/ournewvoice', :to => 'pages#ourvoice'
  match '/redesign', :to => 'pages#ourvoice'

  match '/apply', :to => 'pages#apply'

  match '/settings', :to => 'people#settings'
  match '/videos', :to => 'pages#videos'
  match '/election_guide_2012', :to => 'pages#election_guide_2012'
  match '/election_guide_2012/poll_results', :to => 'pages#political_poll_results'
  match '/election_guide_2012/map', :to => 'pages#election_map'
  match '/projects/emersonla', :to => 'pages#emersonla'
  match '/projects/emersonla/stories', :to => 'pages#emersonla_videos'
  match '/projects/commencement2014', :to => 'pages#commencement2014'
  match '/projects/campusdata', to: 'pages#campus_data'
  match '/projects/year_in_review_2014', to: 'pages#year_in_review_2014'
  match '/projects/race_at_emerson', to: 'pages#race_at_emerson'
  match '/projects/snow_calculator', to: 'pages#snow_calculator'
  match '/projects/website-in-1997', to: 'pages#website1997'
  match '/projects/title_ix', to: 'pages#title_ix'
  match '/projects/housing_in_boston', to: 'pages#neighborhoods2015'
  match '/projects/adjunct_calculator', to: 'pages#adjunct_calculator'
  match '/projects/climate_survey', to: 'pages#climate_survey'
  match '/projects/review_2014_2015', to: 'pages#review_2014_2015'
  
  match '/projects/oscars2012', :to => 'pages#oscars'
  match '/projects/oscars2013', :to => 'pages#oscars2013'
  match '/projects/oscars2014', :to => 'pages#oscars2014'
  match '/projects/oscars2015', to: 'pages#oscars2015'

  match '/api/top5', :to => 'pages#statusboard_top_5_json'
  match '/api/pop_views_ck_data', :to => 'articles#pop_views_ck_data'
  match '/api/special_coverage/new_update', :to => 'special_coverages#new_update', :via => :post
  match '/api/check_slug', to: 'articles#check_slug'
  match '/api/pop_data', to: 'articles#pop_data_api'

  match '/admin/poll_results', :to => 'admin#poll_results'
  match '/admin/published_in_date_range/:dates', to: 'admin#published_in_date_range'
  match '/admin/controls', to: 'admin#controls'
  match '/admin/masthead', to: 'admin#edit_masthead'
  match '/admin/masthead/update', to: 'admin#update_masthead', via: :put

  match '/admin/article', to: 'articles#newnew'

  match '/issues/view/:date', :to => 'issues#show', :via => :get
  match '/events/:uid/:slug', :to => 'events#show'

  match '/issues/latest_rss', :to => 'issues#latest_issue_rss', :format => :rss
  match '/issues/latest_issue_top_story_rss', :to => 'issues#latest_issue_top_story_rss', :format => :rss
  match '/issues/latest_issue_featured_stories_rss', :to => 'issues#latest_issue_featured_stories_rss', :format => :rss
  match '/issues/latest_issue_lead_image_rss', :to => 'issues#latest_issue_lead_image_rss', :format => :rss
  match '/issues/latest_issue_second_image_rss', :to => 'issues#latest_issue_second_image_rss', :format => :rss

  match '/newsletter/signup', to: 'pages#weekly_newsletter'
  match '/outbox/latest_weekly', to: 'outbox#weekly_newsletter'

	resources :stylebook_entries, :except => [:show]
	resources :series, :only => [:new, :create, :edit, :update, :index]
	resources :people
	resources :articles, :only => [:new, :create, :edit, :update, :destroy, :index]
	resources :sessions, :only => [:new, :create, :destroy]
	resources :mediafiles
  resources :blogs, :only => [:new, :create, :edit, :update, :index]
  resources :political_poll_entries, :only => [:index, :new, :create]
  resources :social_posts, :only => [:index, :new, :create, :edit, :update, :destroy]
  resources :home_layouts, :only => [:new, :create]
  resources :short_links, :only => [:index, :create, :update, :destroy]
  resources :issues, :only => [:index, :edit, :update]
  resources :topics, :only => [:create, :edit, :update]
  resources :special_coverages, :only => [:new, :create, :edit, :update]
  resources :events, :except => [:new, :show]

  match '/new_editorial_cartoon', :to => 'pages#new_editorial_cartoon'
  match '/opinion/editorial_cartoons', :to => 'pages#editorial_cartoons'

  match '/pgvw/:article_id', :to => 'articles#increase_pageview'

	match '/login', :to => 'sessions#new'
	match '/logout', :to => 'sessions#destroy'
	match '/about', :to => 'pages#about'
	root :to => 'pages#home'
  # root :to => 'pages#static_home'

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
  controller :topics do
    match "/topics/:slug", :to => :show
  end
  controller :series do
    match "/series/:slug", to: :show
  end

  match '/go/:slug', :to => 'short_links#redirect'


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
