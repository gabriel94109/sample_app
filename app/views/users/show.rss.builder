xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Ruby on Rails Tutorial Sample App / " + @title
    xml.description "Microposts from #{@user.name}"
    xml.link user_url

    for post in @microposts
      xml.item do
        xml.title post.content
        xml.link(request.protocol + request.host_with_port + 
                 url_for(:controller => 'microposts', :action => 'show', :id => post.id))
        xml.description post.content
        xml.guid(request.protocol + request.host_with_port + 
                 url_for(:controller => 'microposts', :action => 'show', :id => post.id))
        xml.pubDate post.updated_at.to_s(:rfc822)
      end
    end
  end
end
