module Youtube
  ##
  # Represents an individual playlist. A single Playlist object can be
  # instantiated with a playlist id. The id can be found in the url 
  # and a few other places: gdata.youtube.com/feeds/api/playlists/<b>AAE42E282C4AD007</b>?v=2
  # 
  # === Example
  #  playlist = Youtube::Playlist.new "AAE42E282C4AD007"
  #  playlist.title # "Mestre Jogo de Dentro & Seus Alunos"
  #  playlist.id # "AAE42E282C4AD007" 
  #  playlist.author # "stephensam" 
  #  playlist.url #"\http://gdata.youtube.com/feeds/api/playlists/AAE42E282C4AD007" 
  #  videos = playlist.videos(3) # returns 3 videos

  class Playlist
    #--
    # TODO reduce the duplication between this and the video class
    #++
    #include Naming from ActiveRecord if its here.
    begin
      self.extend ActiveModel::Naming
    rescue NameError => e
      #do nothing 
    end
  
    ##
    # Instantiate individual instances of this class with a
    # YouTube id.

    def initialize entry

      define_attrs

      if ((entry) && (entry.class == REXML::Element))
        @xml = entry
        @id = /\w{16}/.match(@xml.elements['id'].text).to_s
        populate_attrs

      elsif((entry.class==String)&&(entry =~ /\w{16}/))
        @id = entry.to_s
      else
        raise "The Playlist class did not understand the parameter it was initialized with."
      end
        @url = "http://gdata.youtube.com/feeds/api/playlists/#{@id}"
    end


  
    def self.name # :nodoc:
      "Playlist"
    end

    ##
    # Returns the gdata api url of the playlist.
    # If you want the human friendly url pass in :human as an argument.
    def url type = :api
      type == :human ? @human_url : @url
    end
  
    ##
    # This is the main raison d'être of the Playlist class:
    # to retrieve a set of videos. If you want/need to you can 
    # pass a integer like 5 to limit the number of videos returned.
    #
    def videos limit=nil
  
      case 
      when limit.nil?     
        get_videos unless @videos
      when limit
        if limit == @limit
          get_videos(limit) unless @videos
        else
          get_videos(limit)
          @limit = limit
        end
      else
        puts "Your case has gone badly wrong"
      end
      @videos
    end
  
    private
  
    def populate_attrs # :nodoc:
      @client ||= GData::Client::YouTube.new
      @xml ||= @client.get(self.url).to_xml

      @title =  @xml.elements['title'].text
      @author =  @xml.elements['author/name'].text
      @human_url = @xml.elements['link'].attribute('href').value
    end

    def define_attrs # :nodoc:
      [:title, :author, :id].each do |attr|
        method_def = <<-EOM
          def #{attr}
            if @#{attr}
              @#{attr}.to_s
            else
              populate_attrs
              @#{attr}.to_s
            end
          end
        EOM
        Playlist.class_eval method_def
      end
    end
    def get_videos number=nil
          @client ||= GData::Client::YouTube.new
        feed = @client.get(self.url).to_xml
          @videos = []
        counter = 1 
        if number
            feed.elements.each('entry') do |entry|
            if counter <= number
      	@videos<< Youtube::Video.new(entry)
      	counter += 1
            end
          end
        else
            feed.elements.each('entry') do |entry|
            @videos<< Youtube::Video.new(entry)
          end
        end
    end
  end
end
