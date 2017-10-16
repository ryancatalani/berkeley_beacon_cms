class HomeLayout < ActiveRecord::Base

	serialize :articles

	# layout_type DEFAULT = 1

	# articles = {}
	# articles[:lead] = INTEGER
	# articles[:featured] = [ ... ]
	# articles[:middle] = [ ... ]

end
