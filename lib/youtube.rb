module Youtube
    require 'rubygems'
    require 'gdata'
    require 'rexml/document'  
    def Youtube.playlists_for user
      @client = GData::Client::YouTube.new
      feed = @client.get("http://gdata.youtube.com/feeds/api/users/#{user}/playlists?v=2").to_xml
      playlists = []
      feed.elements.each('entry') do |entry| 
  	playlists<< Playlist.new(entry)
      end
      playlists
    end  
   
  
  
  
end
