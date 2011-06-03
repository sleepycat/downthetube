class Youtube
  require 'rubygems'
  require 'gdata'

  def Youtube.playlists_for user
    @client = GData::Client::YouTube.new
    feed = @client.get("http://gdata.youtube.com/feeds/api/users/#{user}/playlists?v=2").to_xml
    playlists = []
    feed.elements.each('entry') do |entry| 
	playlists<< Playlist.new(entry)
    end
    playlists
  end  
 

  class Playlist
    attr_reader :title, :author, :url, :id

    def initialize entry
      if ((entry) && (entry.class == REXML::Element))
        @xml = entry
        @id = @xml.get_text('yt:playlistId')
        @title =  @xml.get_text('title')
        @author =  @xml.get_text('author/name')
        @xml.each_element_with_attribute('src'){|a| @url = a.attribute('src').to_s }
      elsif((entry.class==String)&&(entry =~ /\w{16}/))
	@url = "http://gdata.youtube.com/feeds/api/playlists/#{entry}"
      else
	raise "The Playlist class did not understand the parameter it was initialized with."
      end
    end

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

    def get_videos number=nil
          @client ||= GData::Client::YouTube.new
	  feed = @client.get(self.url).to_xml
          @videos = []
	  counter = 1 
	  if number
            feed.elements.each('entry') do |entry|
	      if counter <= number
		@videos<< Video.new(entry)
		counter += 1
	      end
	    end
	  else
            feed.elements.each('entry') do |entry|
	      @videos<< Video.new(entry)
	    end
	  end
    end
    
  end


  class Video
    attr_reader :url, :title, :description, :id, :thumbnail, :uploader, :duration

    def initialize entry
      if entry.class == REXML::Element
        @xml = entry
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
      else
	raise "What was passed into Playlist class was not an REXML object"
      end
    end
    
    extend ActiveModel::Naming

    def name
      "Video"
    end

    
    def thumbnail size=:small
      if size == :large
	@large_thumbnail
      else
	@small_thumbnail
      end	
    end


  end


end
