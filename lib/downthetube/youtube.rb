module Youtube
    require 'rubygems'
    require 'gdata'
    require 'rexml/document'  

    ##
    # This is the main entry point. It accepts a YouTube 
    # username such as <tt>stephensam</tt> and returning an array
    # of playlists belonging to that user.
    #
    # === Example
    # playlists = Youtube.playlists_for("stephensam") # returns playlists for user <tt>stephensam</tt>
 

    def Youtube.playlists_for user
      youtube = YT.new()
      feed = youtube.feed_for(user)
      playlists = []
      feed.elements.each('entry') do |entry| 
  	playlists<< Playlist.new(entry)
      end
      playlists
    end  


    class RetrievalError < StandardError
    end

    class YT  # :nodoc: all

      def feed_for user
        client = get_client
        begin
          response = client.get("http://gdata.youtube.com/feeds/api/users/#{user}/playlists?v=2")
          response.to_xml
        rescue Exception => e
          raise Youtube::RetrievalError.new(e.message)
        end
      end

      def get_client 
        client = GData::Client::YouTube.new
      end
    end
end
