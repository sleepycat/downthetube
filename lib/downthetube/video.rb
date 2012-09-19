require 'open-uri'
module Youtube
  ##
  # The video class rather unsurprisingly represents an individual
  # YouTube video. 
  # 
  # === Example
  #   video = playlist.videos.first
  #   video.title # "Semeando 2010 - Mestre Jogo de Dentro" 
  #   video.duration #returns number of seconds: "93" 
  #   video.description # "2010 o VII Encontro Internacional de Capoeira Angola... " 
  #   video.thumbnail(:large) # "\http://i.ytimg.com/vi/4YMMWt2808U/hqdefault.jpg" 
  #   video.id # "4YMMWt2808U" 
  #   video.uploader # "micheldezen" 
  #   video.url # "http://www.youtube.com/watch?v=4YMMWt2808U"

  class Video
    #include Naming from ActiveRecord if its here.
    begin
      self.extend ActiveModel::Naming
    rescue NameError => e
      #do nothing 
    end
    
    def initialize entry
      
      define_attrs

      if entry.class == REXML::Element
        @xml = entry
      elsif((entry.class == String)&&(entry =~/(\w|-){11}/))
        @url = "http://gdata.youtube.com/feeds/api/videos/#{entry}?v=2"
      else
	raise "What was passed into Playlist class was not an REXML object"
      end
    end

    ##
    # Returns the url of the video
    def url
      populate_attrs unless @url
      @url
    end

    
    def self.name # :nodoc:
      "Video"
    end

    ##
    # Returns the url of the thumbnail image for the video.
    # If you want the large thumbnail pass :large as a parameter.

    def thumbnail size=:small
      populate_attrs unless @large_thumbnail && @small_thumbnail
     if size == :large
	@large_thumbnail
      else
	@small_thumbnail
      end	
    end
    
    ##
    # Returns that the video was instantiated with.
    def to_xml
      @xml.to_s
    end

    ##
    # Returns a hash with the video attributes in it.
    def to_h
      populate_attrs unless @xml
        h = {}
      instance_variables.each do |var| 
        h[var.to_s.gsub('@', '').to_sym]= self.instance_variable_get(var.to_sym).to_s unless [:@client, :@xml].include? var
      end
      h
    end

    private

    def define_attrs
      [:title, :description, :id, :uploader, :duration].each do |attr|
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
        Video.class_eval method_def
      end
    end

    def populate_attrs
        
        @client ||= GData::Client::YouTube.new
        @xml ||= @client.get(self.url).to_xml


        @xml.elements.each('media:group') do |element| 
	  @title =  element.get_text('media:title')
	  @id = element.get_text('yt:videoid')
	  @description = element.get_text('media:description')
	  @uploader =  element.get_text('media:credit')
	  element.elements.each('media:player'){|mp| @url = mp.attribute('url').to_s.gsub('&amp;feature=youtube_gdata_player', '')}
          element.elements.each('yt:duration'){|a| @duration = a.attribute('seconds').to_s }
          element.elements.each('media:thumbnail') do |mt|
	    case mt.attribute('yt:name').to_s
	      when 'hqdefault'
		@large_thumbnail = mt.attribute('url').to_s
	      when 'default'
		@small_thumbnail = mt.attribute('url').to_s
	    end
	  end
	end
    end
  end
end

