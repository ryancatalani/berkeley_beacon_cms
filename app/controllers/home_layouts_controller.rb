class HomeLayoutsController < ApplicationController
	before_filter :check_editor

  def new
  	@home_layout = HomeLayout.new
  	as = Issue.last.article.count > 0 ? Issue.last.articles : Issue.first(2).last.articles rescue Article.last(30)
    @articles = as.sort {|x,y| x.section_id <=> y.section_id }

    if HomeLayout.last
      previous_layout = {}
      latest = HomeLayout.last.articles
      previous_layout_lead_title = Article.find(latest[:lead]).title rescue "[Can't find title]"
      previous_layout[:lead] = { :title => previous_layout_lead_title, :id => latest[:lead] }
      previous_layout[:featured] = []
      previous_layout[:middle] = []
      latest[:featured].each do |id|
        previous_layout[:featured] << { :title => Article.find(id).title, :id => id }
      end
      latest[:middle].each do |id|
        previous_layout[:middle] << { :title => Article.find(id).title, :id => id }
      end
      @previous_layout_js = previous_layout.to_json
    end

  	render 'new', :layout => 'editor_stripped'
  end

  def create
  	layout_type = 1

  	lead = params[:lead].to_i
  	featured = [ params[:featured_0], params[:featured_1], params[:featured_2] ].map(&:to_i)
  	middle = [ params[:middle_0], params[:middle_1], params[:middle_2], params[:middle_3], params[:middle_4] ].map(&:to_i)

  	articles = {}
  	articles[:lead] = lead
  	articles[:featured] = featured
  	articles[:middle] = middle

  	@home_layout = HomeLayout.new(:layout_type => layout_type, :articles => articles)
  	if @home_layout.save
  		redirect_to articles_path
  	else
  		render 'new'
  	end
  end

end
