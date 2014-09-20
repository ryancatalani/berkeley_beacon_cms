xml.instruct!
xml.rss :version => '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do

  xml.channel do
    xml.title 'The Berkeley Beacon'
    xml.description "#{@issue.release_date.strftime('%B %e, %Y')} print edition"
    xml.link root_url
    xml.language 'en'
    xml.tag! 'atom:link', :rel => 'self', :type => 'application/rss+xml', :href => issues_latest_rss_url

    for article in @articles
      xml.item do
        xml.title article.extra_title
        xml.link article.to_url
        xml.pubDate(@issue.release_date.rfc2822)
        xml.guid article.cleantitle
        xml.description article.excerpt
        xml.author bylineify(article)
        xml.tag!('media:content', 
          url: article.first_photo.media.thumb_460,
          medium: 'image',
          height: 460,
          width: 460) if article.first_photo
      end
    end

  end

end