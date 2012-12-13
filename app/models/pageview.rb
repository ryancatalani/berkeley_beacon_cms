class Pageview < ActiveRecord::Base
	belongs_to :obj_pageviews, :polymorphic => true

end
