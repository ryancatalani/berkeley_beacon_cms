class HomeLayoutsController < ApplicationController
	before_filter :check_editor

  def new
  	@home_layout = HomeLayout.new

    as = nil
    @articles = nil

    begin
      if Issue.latest.articles.count > 0
        as = Issue.latest.articles
        @articles = as.where(draft: false).sort {|x,y| x.section_id <=> y.section_id }
      else
        as = Article.last(30)
        @articles = as.delete_if{ |a| a.draft? }.sort {|x,y| x.section_id <=> y.section_id }
      end
    rescue
      as = Article.last(30)
      @articles = as.delete_if{ |a| a.draft? }.sort {|x,y| x.section_id <=> y.section_id }
    end

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

  	lead = std_ref(params[:lead])
  	featured = [ params[:featured_0], params[:featured_1], params[:featured_2] ].map{|r| std_ref(r)}
  	middle = [ params[:middle_0], params[:middle_1], params[:middle_2], params[:middle_3], params[:middle_4] ].map{|r| std_ref(r)}

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

    lead_is_standalone_photo = params[:lead_is_standalone_photo]

  	articles = {}
  	articles[:lead] = lead
  	articles[:featured] = featured
  	articles[:middle] = middle
    articles[:should_use_photo] = should_use_photo
    articles[:lead_is_standalone_photo] = lead_is_standalone_photo

  	@home_layout = HomeLayout.new(:layout_type => layout_type, :articles => articles)
  	if @home_layout.save
  		redirect_to articles_path
  	else
  		render 'new'
  	end
  end

  private

  def home_layout_params
    params.require(:home_layout).permit(:layout_type, :articles, :breaking_text, :breaking_article, :custom_top_html)
  end

  def std_ref(ref)
    if ref.include?('berkeleybeacon.com') || ref.include?('localhost:3000')
      slug = ref.split('/').pop
      id = Article.where(cleantitle: slug).order('created_at DESC').first.id
      return id
    else
      return ref.to_i
    end
  end

end
