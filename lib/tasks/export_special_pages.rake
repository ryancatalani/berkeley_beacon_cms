require 'csv'

namespace :export do
	desc "Export special pages to CSV"
	task :special_pages => :environment do

		projects = {
			'/election_guide_2012' => {
				action: 'election_guide_2012_export',
				locals: {
					:@og => {
						title: "Beacon Election Guide 2012",
						image: "http://s3.amazonaws.com/BerkeleyBeacon/beacon_uploads/uploads/election_guide_thumb.jpg",
						description: "A special political section with op-eds, the Beacon's poll results, and more."
					}
				}
			},
			'/election_guide_2012/poll_results' => {
				action: 'political_poll_results_export',
				locals: {
					:@og => {
						title: "Poll Results | Beacon Election Guide 2012",
						image: "http://s3.amazonaws.com/BerkeleyBeacon/beacon_uploads/uploads/poll_thumb_460.jpg",
						description: "See how Emerson students stand on election issues."						
					}
				}
			},
			'/election_guide_2012/map' => {
				action: 'election_map',
				locals: {
					:@og => {
						title: "Voting Locations | Beacon Election Guide 2012",
						image: "http://s3.amazonaws.com/BerkeleyBeacon/beacon_uploads/uploads/voting%20map-01-thumb.jpg",
						description: "See voting locations around Boston, and how to find out where to vote."
					}
				}
			},
			'/projects/emersonla' => {
				action: 'emersonla',
				layout: 'bare_export',
				locals: emersonla_locals
			},
			'/projects/emersonla/stories' => {
				action: 'emersonla_videos',
				layout: 'bare_export',
				locals: {
					:@body_id => "emersonla_videos",
					:@include_responsive => true,
					:@use_roboto => true,
					:@use_videojs => true,
					:@title => "Emerson LA: Stories",
					:@og => {
						description: "Videos about Emerson's new campus and community in Hollywood.",
						image: "http://s3.amazonaws.com/BerkeleyBeacon/beacon_uploads/uploads/ela_videos_cover.jpg"	
					}
				}
			},
			'/projects/commencement2014' => {
				action: 'commencement2014',
				layout: 'bare_export',
				locals: commencement2014_locals
			},
			'/projects/race_at_emerson' => {
				action: 'race_at_emerson',
				layout: 'bare_export',
				locals: {
					:@body_id => "raceseries",
					:@include_responsive => true,
					:@title => "A half-century of race relations at Emerson",
					:@og => {
						description: "An in-depth look at the protests, tenure controversies, administrators, and admissions policies that continue to shape race relations.",
						image: "http://theberkeleybeacon.s3.amazonaws.com/race_intro.jpg"	
					}
				}
			},
			'/projects/snow_calculator' => {
				action: 'snow_calculator_export',
				locals: {
					:@body_id => "snow_calculator",
					:@include_responsive => true,
					:@title => "How much are your missed classes worth?",
					:@no_bootstrap => true,
					:@og => {
						description: "Emerson has canceled several days of classes because of the snow. See how much your missed classes are worth.",
						image: "https://s3.amazonaws.com/BerkeleyBeacon/beacon_uploads/uploads/1423126348-Snowstorm_Bushell_01272015_0021.jpg.jpg"	
					}
				}
			},
			'/projects/website-in-1997' => {
				action: 'website1997',
				locals: {
					:@body_id => "website1997",
					:@title => "The Beacon's website in 1997",
					:@og => {
						description: "This was the Beacon's website in 1997, a time when “online” was still hyphenated and zany Photoshop effects were prized.",
						image: "http://theberkeleybeacon.s3.amazonaws.com/beacon_website_1997.gif"	
					}
				}
			},
			'/projects/housing_in_boston' => {
				action: 'neighborhoods2015_export',
				locals: {
					:@body_id => "neighborhoods2015",
					:@title => "Housing in Boston",
					:@include_responsive => true,
					:@og => {
						description: "Special series: Learn about different Boston-area neighborhoods each week.",
						image: "http://theberkeleybeacon.s3.amazonaws.com/housing_thumb.jpg"
					}
				}
			},
			'/projects/adjunct_calculator' => {
				action: 'adjunct_calculator_export',
				locals: {
					:@body_id => "adjunct_calculator",
					:@title => "Calculate how much your adjunct professors earn.",
					:@no_bootstrap => true,
					:@include_responsive => true,
					:@og => {
						description: "Enter your classes and see how much your professors are paid.",
						image: "http://theberkeleybeacon.s3.amazonaws.com/beacon_1000x1000.jpg"
					}
				}
			},
			'/projects/climate_survey' => {
				action: 'climate_survey',
				layout: 'bare_export',
				locals: {
					:@body_id => "climate_survey",
					:@title => "Surveying Emerson's Climate",
					:@no_bootstrap => true,
					:@include_responsive => true,
					:@og => {
						description: "Explore the results from Emerson's first comprehensive climate survey.",
						image: "http://theberkeleybeacon.s3.amazonaws.com/climate-survey/climatesurveyhead_web.jpg"
					}
				}
			},
			'/projects/review_2014_2015' => {
				action: 'review_2014_2015_export',
				layout: 'bare_export',
				locals: {
					:@body_id => "review_2014_2015",
					:@title => "2014–2015: A school year in review",
					:@no_bootstrap => true,
					:@include_responsive => true,
					:@og => {
						description: "A look back at the news and trends that shaped this school year.",
						image: "http://theberkeleybeacon.s3.amazonaws.com/yearinreview/yearinreview_social.jpg"
					}
				}
			},
			'/projects/oscars2012' => {
				action: 'oscars_export',
				locals: {
					:@title => "Oscar Predictions",
					:@include_bootstrap => true
				}
			},
			'/projects/oscars2013' => {
				action: 'oscars2013',
				locals: {
					:@title => "2013 Oscar Predictions",
					:@include_bootstrap => true,
					:@needs_og => true,
					:@og => {
						title: "The Beacon's Oscar picks",
						image: "http://s3.amazonaws.com/BerkeleyBeacon/beacon_uploads/uploads/zero_web_thumb.jpg",
						description: "See the films that Beacon staff members think should win Academy Awards."
					}
				}
			},
			'/projects/oscars2014' => {
				action: 'oscars2014_export',
				locals: {
					:@title => "The Beacon's 2014 Oscar Picks",
					:@needs_og => true,
					:@include_responsive => true,
					:@og => {
						title: "The Beacon's Oscar picks",
						url: "http://berkeleybeacon.com/oscars",
						image: "https://theberkeleybeacon.s3.amazonaws.com/static/assets/oscars-ejiofor.jpg",
						description: "See the films that Beacon staff members think should win Academy Awards."
					}
				}
			},
			'/projects/oscars2015' => {
				action: 'oscars2015',
				locals: {
					:@body_id => "oscars2015",
					:@include_responsive => true,
					:@title => "The Beacon's 2015 Oscar Picks",
					:@og => {
						description: "See the films that Beacon staff members think should win Academy Awards.",
						image: "http://theberkeleybeacon.s3.amazonaws.com/oscars2015/oscars_preview.jpg"
					}
				}
			}
		}

		final = []
		headers = %w(title slug html)

		projects.each do |route, project|

			ret = ApplicationController.new.render_to_string(
				template: "pages/#{project[:action]}",
				layout: project[:layout] || 'application_export',
				locals: project[:locals]
			).delete("\n").delete("\t")

			title = project[:locals][:@title] || project[:locals][:@og][:title] || route

			project_csv = [
				title,
				route,
				ret
			]
			final << project_csv
		end

		CSV.open(Rails.root.join("projects_export.csv"), "w") do |csv|
			csv << headers
			final.each do |row|
				csv << row
			end
		end


	end
end

def emersonla_locals
	locals = {}

	locals[:@body_id] = "emersonla"
	locals[:@include_responsive] = true
	locals[:@title] = "Emerson LA: Special Coverage"
	locals[:@og] ||= {}
	locals[:@og][:description] = "Articles, photos, and videos with an in-depth look at the new Emerson Los Angeles in Hollywood."
	locals[:@og][:image] = "https://s3.amazonaws.com/BerkeleyBeacon/beacon_uploads/uploads/thumb_460_1389855659-LALeadArt1_Catalani_forweb.jpg.jpg"

	@sc = SpecialCoverage.find_by_title("Emerson LA")
	locals[:@sc] = @sc
	locals[:@lead] = Article.find(@sc.lead) rescue nil
	locals[:@featured] = @sc.featured.map{|id| Article.find(id)} rescue nil
	locals[:@related_t] = Topic.find(@sc.related_topic) rescue nil
	locals[:@related_a] = @sc.related_articles.map{|id| Article.find(id)} rescue nil
	locals[:@updates] = @sc.updates.reverse rescue []
	locals[:@media] = @sc.media.map{|id| Mediafile.find(id)} rescue nil

	return locals
end

def commencement2014_locals
	locals = {}

	locals[:@body_id] = "commencement2014"
	locals[:@include_responsive] = true
	locals[:@title] = "Commencement 2014: Special Coverage"
	locals[:@og] ||= {}
	locals[:@og][:description] = "Liveblog, articles, and photos, with an in-depth look at Emerson's 134th commencement."

	@sc = SpecialCoverage.find_by_title("Commencement 2014")
	locals[:@sc] = @sc
	locals[:@lead] = Article.find(@sc.lead) rescue nil
	locals[:@featured] = @sc.featured.map{|id| Article.find(id)} rescue nil
	locals[:@related_t] = Topic.find(@sc.related_topic) rescue nil
	locals[:@related_a] = @sc.related_articles.map{|id| Article.find(id)} rescue nil
	locals[:@updates] = @sc.updates.reverse rescue []
	locals[:@media] = @sc.media.map{|id| Mediafile.find(id)} rescue nil

	return locals
end