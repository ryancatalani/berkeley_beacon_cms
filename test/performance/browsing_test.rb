require 'test_helper'
require 'rails/performance_test_help'

class BrowsingTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { :runs => 5, :metrics => [:wall_time, :memory]
  #                          :output => 'tmp/performance', :formats => [:flat] }

  # def test_homepage
  #   get '/'
  # end

	def popular_articles_a
	  	num = 5
		num_days = 2
		ret = Article.where(:created_at => (Time.now.midnight - num_days.days)..(Time.now.midnight + 1.day)).order("views DESC").first(num)
		while ret.count < num
			num_days += 1
			ret << Article.where(:created_at => (Time.now.midnight - num_days.days)..(Time.now.midnight + 1.day)).order("views DESC").first(num)
			ret.flatten!
			ret.uniq!
		end
		return ret.first(num)
	end
	
end
