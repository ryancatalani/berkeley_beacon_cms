BeaconApp::Application.routes.draw do

  get "outbox/weekly_newsletter"

	controller :people do
		get "/staff/:name", :to => :show
	end

  get '/search', to: 'pages#search_frontend', as: 'search'

	get '/stylebook', :to => 'stylebook_entries#index'
	get '/tips', :to => 'pages#tips'
	match '/send_tip', :to => 'pages#send_tip', :via => :post
	match '/new_media_person', :to => 'people#new_media_person', :via => :post
	match '/new_tag/:tag_id/article/:article_id', :to => 'taggings#new_tagging', :via => :post

  get '/ecla', :to => 'pages#emersonla'
  get '/emersonla', :to => 'pages#emersonla'
  # match '/emersonla-live', :to => 'pages#emersonla_live'
  # match '/beacon_ecla_tweets', :to => 'pages#beacon_ecla_tweets'
  # match '/all_ecla_tweets', :to => 'pages#all_ecla_tweets'

  match '/archive_problem/:url', :to => 'pages#archive_problem', :via => :post

  get '/ourvoice', :to => 'pages#ourvoice'
  get '/ournewvoice', :to => 'pages#ourvoice'
  get '/redesign', :to => 'pages#ourvoice'

  get '/apply', :to => 'pages#apply'

  get '/settings', :to => 'people#settings'
  get '/videos', :to => 'pages#videos'
  get '/election_guide_2012', :to => 'pages#election_guide_2012'
  get '/election_guide_2012/poll_results', :to => 'pages#political_poll_results'
  get '/election_guide_2012/map', :to => 'pages#election_map'
  get '/projects/emersonla', :to => 'pages#emersonla'
  get '/projects/emersonla/stories', :to => 'pages#emersonla_videos'
  get '/projects/commencement2014', :to => 'pages#commencement2014'
  get '/projects/campusdata', to: 'pages#campus_data'
  get '/projects/year_in_review_2014', to: 'pages#year_in_review_2014'
  get '/projects/race_at_emerson', to: 'pages#race_at_emerson'
  get '/projects/snow_calculator', to: 'pages#snow_calculator'
  get '/projects/website-in-1997', to: 'pages#website1997'
  get '/projects/title_ix', to: 'pages#title_ix'
  get '/projects/housing_in_boston', to: 'pages#neighborhoods2015'
  get '/projects/adjunct_calculator', to: 'pages#adjunct_calculator'
  get '/projects/climate_survey', to: 'pages#climate_survey'
  get '/projects/review_2014_2015', to: 'pages#review_2014_2015'
  
  get '/projects/oscars2012', :to => 'pages#oscars'
  get '/projects/oscars2013', :to => 'pages#oscars2013'
  get '/projects/oscars2014', :to => 'pages#oscars2014'
  get '/projects/oscars2015', to: 'pages#oscars2015'

  get '/api/top5', :to => 'pages#statusboard_top_5_json'
  get '/api/pop_views_ck_data', :to => 'articles#pop_views_ck_data'
  match '/api/special_coverage/new_update', :to => 'special_coverages#new_update', :via => :post
  get '/api/check_slug', to: 'articles#check_slug'
  get '/api/pop_data', to: 'articles#pop_data_api'
  get '/api/series/:slug', to: 'series#api_list_by_slug'
  get '/api/topics/:slug', to: 'topics#api_list_by_slug'
  get '/api/sections/:slug', to: 'sections#api_list_by_slug'
  get '/api/search_article_data', to: 'articles#search_edit_frontend_data'

  get '/admin/poll_results', :to => 'admin#poll_results'
  get '/admin/published_in_date_range/:dates', to: 'admin#published_in_date_range'
  get '/admin/controls', to: 'admin#controls'
  get '/admin/masthead', to: 'admin#edit_masthead'
  match '/admin/masthead/update', to: 'admin#update_masthead', via: :put
  get '/admin/search_edit', :to => 'articles#search_edit_frontend'

  get '/opinion/editorial_cartoons',    to: 'editorial_cartoons#index'
  get '/admin/editorial_cartoons',      to: 'editorial_cartoons#edit_index'
  get "/new_editorial_cartoon"          => redirect("/editorial_cartoons/new")
  resources :editorial_cartoons

  get '/admin/article', to: 'articles#newnew'

  get '/issues/view/:date', :to => 'issues#show'
  get '/events/:uid/:slug', :to => 'events#show'

  get '/issues/latest_rss', :to => 'issues#latest_issue_rss', :format => :rss
  get '/issues/latest_issue_top_story_rss', :to => 'issues#latest_issue_top_story_rss', :format => :rss
  get '/issues/latest_issue_featured_stories_rss', :to => 'issues#latest_issue_featured_stories_rss', :format => :rss
  get '/issues/latest_issue_lead_image_rss', :to => 'issues#latest_issue_lead_image_rss', :format => :rss
  get '/issues/latest_issue_second_image_rss', :to => 'issues#latest_issue_second_image_rss', :format => :rss

  get '/newsletter/signup', to: 'pages#weekly_newsletter'
  get '/outbox/latest_weekly', to: 'outbox#weekly_newsletter'

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
  resources :special_coverages, :only => [:index, :new, :create, :edit, :update]
  resources :events, :except => [:new, :show]
  resources :custom_pages, only: [:new, :create, :edit, :update]

  get '/special/:id/:slug', to: 'special_coverages#show'

  get '/pgvw/:article_id', :to => 'articles#increase_pageview'

	get '/login', :to => 'sessions#new'
	get '/logout', :to => 'sessions#destroy'
	get '/about', :to => 'pages#about'
	root :to => 'pages#home'
  # root :to => 'pages#static_home'

	controller :articles do
		scope ":sectionname" do
			scope ":year" do
				scope ":month" do
					scope ":day" do
						get ":title", :to => :show, :as => :getselectedarticle
					end
				end
			end
		end
	end

  get "/arts-and-entertainment" => redirect("/arts")
	controller :sections do
		get ":name", :to => :show
	end
  controller :blogs do
    get "/blogs/:name", :to => :show
  end
  controller :topics do
    get "/topics/:slug", :to => :show
  end
  controller :series do
    get "/series/:slug", to: :show
  end

  get '/go/:slug', :to => 'short_links#redirect'


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
