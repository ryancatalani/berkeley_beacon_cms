class HomeLayoutsController < ApplicationController
	before_filter :check_editor

  def new
  	@home_layout = HomeLayout.new
  	as = Issue.latest.articles.count > 0 ? Issue.latest.articles : Article.last(30) rescue Article.last(30)
    @articles = as.sort {|x,y| x.section_id <=> y.section_id }
    begin
      recent_web_articles = Article.where(:issue_id => 0, :created_at => (Time.now.midnight-7.days)..(Time.now.midnight+1.day)).all
      @articles.prepend(recent_web_articles).flatten!
    rescue
    end

    if HomeLayout.last
      begin
        previous_layout = {}
        latest = HomeLayout.last.articles
        previous_layout_lead_title =
        previous_layout[:lead] = { :title => Article.find(latest[:lead]).title, :id => latest[:lead] }
        previous_layout[:featured] = []
        previous_layout[:middle] = []
        latest[:featured].each do |id|
          previous_layout[:featured] << { :title => Article.find(id).title, :id => id }
        end
        latest[:middle].each do |id|
          previous_layout[:middle] << { :title => Article.find(id).title, :id => id }
        end
        @previous_layout_js = previous_layout.to_json
      rescue
        # Fix?
      end
    end

  	render 'new', :layout => 'editor_stripped'
  end

  def create
  	layout_type = 1

  	lead = params[:lead].to_i
  	featured = [ params[:featured_0], params[:featured_1], params[:featured_2] ].map(&:to_i)
  	middle = [ params[:middle_0], params[:middle_1], params[:middle_2], params[:middle_3], params[:middle_4] ].map(&:to_i)

    should_use_photo = {}
    lead_photo = params[:lead_should_use_photo]
    featured_photo = [
      params[:featured_0_should_use_photo],
      params[:featured_1_should_use_photo],
      params[:featured_2_should_use_photo]
    ]
    middle_photo = [
      params[:middle_0_should_use_photo],
      params[:middle_1_should_use_photo],
      params[:middle_2_should_use_photo],
      params[:middle_3_should_use_photo],
      params[:middle_4_should_use_photo]
    ]
    should_use_photo[:lead] = lead_photo
    should_use_photo[:featured] = featured_photo
    should_use_photo[:middle] = middle_photo

  	articles = {}
  	articles[:lead] = lead
  	articles[:featured] = featured
  	articles[:middle] = middle
    articles[:should_use_photo] = should_use_photo

  	@home_layout = HomeLayout.new(:layout_type => layout_type, :articles => articles)
  	if @home_layout.save
  		redirect_to articles_path
  	else
  		render 'new'
  	end
  end

end
