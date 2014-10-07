xml.instruct!
xml.rss :version => '2.0', 'xmlns:media' => 'http://search.yahoo.com/mrss/' do

  xml.channel do
    xml.title 'The Berkeley Beacon'
    xml.description "#{@issue.release_date.strftime('%B %e, %Y')} print edition lead image"
    xml.link root_url
    xml.language 'en'
    xml.tag! 'atom:link', :rel => 'self', :type => 'application/rss+xml', :href => issues_latest_issue_lead_image_rss_url

    xml.item do
      xml.title @image.title
      xml.link @image_article_link
      xml.pubDate(@issue.release_date.rfc2822)
      xml.guid @image.id
      xml.description "#{@image.title} • #{bylineify(@image)}"
      xml.author bylineify(@image)
      xml.tag!('media:content', 
        url: @image.media.long_480,
        medium: 'image',
        width: 480)
    end

  end

end