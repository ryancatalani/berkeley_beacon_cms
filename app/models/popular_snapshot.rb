class PopularSnapshot < ActiveRecord::Base
	# most_viewed: [:article_id, INTEGER (views)]
	# most_shared: [:article_id, INTEGER (shares)]

	attr_accessible :most_viewed, :most_shared
	serialize :most_viewed
	serialize :most_shared

	def self.latest_most_viewed
		last.most_viewed.map {|a| Article.find(a[0]) } rescue []
	end

	def self.latest_most_viewed_api
		begin
			viewed_ret = []
			last.most_viewed.each do |a|
				article = Article.find(a[0])
				ret = {
					title: article.extra_title,
					url: article.to_url
				}
				if article.first_photo
					ret[:thumb_40] = article.first_photo.media.thumb_40.url
					ret[:thumb_220] = article.first_photo.media.thumb_220.url
				end
				viewed_ret << ret
			end
			return viewed_ret
		rescue
			return []
		end
	end

	def self.latest_most_shared
		last.most_shared.map {|a| [Article.find(a[0]), a[1]] } rescue []
	end

	def self.latest_most_shared_api
		shared_ret = []
		last.most_shared.each do |a|
			article = Article.find(a[0])
			ret = {
				title: article.extra_title,
				url: article.to_url,
				shares: a[1]
			}
			if article.first_photo
				ret[:thumb_40] = article.first_photo.media.thumb_40.url
				ret[:thumb_220] = article.first_photo.media.thumb_220.url
			end
			shared_ret << ret
		end
		return shared_ret
	end

	def self.top_5
		snapshot_count = 24 * 7
		latest_pop = PopularSnapshot.last(snapshot_count)
		last_time = PopularSnapshot.last.created_at

		# latest_* = [ [hour], [hour], etc ]
		# hour = [ [first most popular], [second most popular], etc ]

		pop_views = latest_pop.map &:most_viewed
		pop_shares = latest_pop.map &:most_shared

		@pop_views_final = {}
		@pop_shares_final = {}

		pop_views.flatten(1).map(&:first).uniq.each do |artcl|
			@pop_views_final[artcl] = Array.new(snapshot_count, 0)
		end

		pop_shares.flatten(1).map(&:first).uniq.each do |artcl|
			@pop_shares_final[artcl] = Array.new(snapshot_count, 0)
		end

		pop_views.each_with_index do |snapshot, i|
			snapshot.each do |inner|
				article_id = inner.first
				count = inner.last
				@pop_views_final[article_id][i] = {
					:time => (last_time - i.hours).to_i,
					:count => count
				}
			end
		end

		pop_shares.each_with_index do |snapshot, i|
			snapshot.each do |inner|
				article_id = inner.first
				count = inner.last
				@pop_shares_final[article_id][i] = {
					:time => (last_time - i.hours).to_i,
					:count => count
				}
			end
		end

		@pop_views_final = @pop_views_final.each {|k,v| v.delete(0) }
		@pop_shares_final = @pop_shares_final.each {|k,v| v.delete(0) }

		# @pop_views_final = @pop_views_final.map{|k,v| v}
		# @pop_shares_final = @pop_shares_final.map{|k,v| v}

		return {
			:views => @pop_views_final,
			:shares => @pop_shares_final
		}

	end

	def self.statusboard_top_5
		top5 = top_5[:views]
		statusboard_colors = ["yellow", "green", "red", "purple", "blue", "mediumGray", "pink", "aqua", "orange", "lightGray"]

		encoding_options = {
		    :invalid           => :replace,  # Replace invalid byte sequences
		    :undef             => :replace,  # Replace anything not defined in ASCII
		    :replace           => '',        # Use a blank for those replacements
		    :universal_newline => true       # Always break lines with \n
		  }

		datasequences = []
		top5.each_with_index do |(k,v),i|
			title = Article.find(k).title.encode(Encoding.find('ASCII'), encoding_options) rescue ""
			datasequences << {
				:title => title,
				:color => statusboard_colors[i % statusboard_colors.count],
				:datapoints => v
			}
		end

		return {
			:graph => {
				:title => "Most viewed articles",
				:datasequences => datasequences
			}
		}
	end

end
