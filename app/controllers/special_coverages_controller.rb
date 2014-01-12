class SpecialCoveragesController < ApplicationController
	def new
		@sc = SpecialCoverage.new
		@latest_articles = [nil,nil] + Article.order("created_at DESC").first(30).map{|a| [a.title, a.id]}
		@topics = [nil,nil] + Topic.all.map{|t| [t.title, t.id]}

		@lead = @sc.lead || nil
		@featured = @sc.featured || nil
		@related_t = @sc.related_topic || nil
		@related_a = @sc.related_articles || nil
	end

	def edit
		@sc = SpecialCoverage.find(params[:id])
		@latest_articles = [nil,nil] + Article.order("created_at DESC").first(30).map{|a| [a.title, a.id]}
		@topics = [nil,nil] + Topic.all.map{|t| [t.title, t.id]}

		@lead = @sc.lead || nil
		@featured = @sc.featured || nil
		@related_t = @sc.related_topic || nil
		@related_a = @sc.related_articles || nil
	end

	def create
		p = params[:special_coverage]
		p[:featured] = params[:featured].map(&:to_i)
		p[:related_articles] = params[:related_articles].map(&:to_i)
		@sc = SpecialCoverage.new(p)
		if @sc.save
			redirect_to edit_special_coverage_path(@sc)
		else
			render "new"
		end
	end

	def update
		p = params[:special_coverage]
		p[:featured] = params[:featured].map(&:to_i)
		p[:related_articles] = params[:related_articles].map(&:to_i)
		@sc = SpecialCoverage.find(params[:id])
		if @sc.update_attributes(p)
			redirect_to edit_special_coverage_path(@sc)
		else
			render "edit"
		end
	end


	def new_update
		update = {}
	end
end
