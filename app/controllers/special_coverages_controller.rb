class SpecialCoveragesController < ApplicationController

	before_filter :check_editor, :except => [:show]


	def index
		@sc = SpecialCoverage.all
	end


	def new
		@sc = SpecialCoverage.new
		@latest_articles = [nil,nil] + Article.order("created_at DESC").first(30).map{|a| [a.title, a.id]}
		@topics = [nil,nil] + Topic.all.map{|t| [t.title, t.id]}

		@lead = @sc.lead || nil
		@featured = @sc.featured || nil
		@related_t = @sc.related_topic || nil
		@related_a = @sc.related_articles || nil

		@updates = @sc.updates || []

		@media = @sc.media || nil
		@media_ids = @sc.media.join(',') rescue nil
		@authors = Person.order("firstname ASC").all.map { |person| [person.official_name, person.id] }
		@authors.unshift(["Choose an author",0])

	end

	def edit
		@sc = SpecialCoverage.find(params[:id])
		@latest_articles = [nil,nil] + Article.order("created_at DESC").first(30).map{|a| [a.title, a.id]}
		@topics = [nil,nil] + Topic.all.map{|t| [t.title, t.id]}

		@lead = @sc.lead || nil
		@featured = @sc.featured || nil
		@related_t = @sc.related_topic || nil
		@related_a = @sc.related_articles || nil

		@updates = @sc.updates || []

		@media = @sc.media || nil
		@media_ids = @sc.media.join(',') rescue nil
		@authors = Person.order("firstname ASC").all.map { |person| [person.official_name, person.id] }
		@authors.unshift(["Choose an author",0])
	end

	def create
		p = params[:special_coverage]
		p[:featured] = params[:featured].map(&:to_i) rescue nil
		p[:related_articles] = params[:related_articles].map(&:to_i) rescue nil
		p[:media] = params[:media_ids].split(',').map(&:to_i) rescue nil
		@sc = SpecialCoverage.new(p)
		if @sc.save
			redirect_to edit_special_coverage_path(@sc)
		else
			render "new"
		end
	end

	def update
		p = params[:special_coverage]
		p[:featured] = params[:featured].map(&:to_i) rescue nil
		p[:related_articles] = params[:related_articles].map(&:to_i) rescue nil
		p[:media] = params[:media_ids].split(',').map(&:to_i) rescue nil
		@sc = SpecialCoverage.find(params[:id])
		if @sc.update_attributes(p)
			redirect_to edit_special_coverage_path(@sc)
		else
			render "edit"
		end
	end

	def new_update
		update = {}
		update[:title] = params[:title] unless params[:title].blank?
		update[:body] = params[:body] unless params[:body].blank?
		update[:ts] = Time.now.to_i

		if !params[:tweet].blank?
			begin
				t_id = params[:tweet].split('/').pop
				t_api_url = "https://api.twitter.com/1/statuses/oembed.json?id=" + t_id
				uri = URI.parse(t_api_url)
				req = Net::HTTP::Get.new(uri.request_uri)
				http = Net::HTTP.new(uri.host, uri.port)
				http.use_ssl = true
				http.verify_mode = OpenSSL::SSL::VERIFY_NONE
				res = http.request(req)
				t_res = JSON.parse(res.body)
				update[:twitter_embed] = t_res["html"]
			rescue
			end

			update[:twitter_url] = params[:tweet]
		end

		sc = SpecialCoverage.find(params[:sc_id])
		sc_updates = sc.updates || []
		sc_updates.push(update)
		sc.update_attribute(:updates, sc_updates)

		@u = update

		# render :json => update
	end

	def show
		@sc = SpecialCoverage.find(params[:id])

		@include_responsive = true
		@title = "#{@sc.title}: Special Coverage"
		@og ||= {}
		@og[:description] = "Read the Beacon's in-depth coverage about #{@sc.title}"

		@first_photo_url = nil
		if @sc.media && @sc.media.any?
			begin
				@first_photo_url = Mediafile.find(@sc.media.first).media.url
				@og[:image] = @first_photo_url
			rescue
				@og[:image] = nil
			end
		end

		@lead = Article.find(@sc.lead) rescue nil
		@featured = @sc.featured.map{|id| Article.find(id)} rescue nil
		@related_t = Topic.find(@sc.related_topic) rescue nil
		@related_a = @sc.related_articles.map{|id| Article.find(id)} rescue nil
		@updates = @sc.updates.reverse rescue []
		@media = @sc.media.map{|id| Mediafile.find(id)} rescue nil

		render :layout => 'bare'
	end
end
