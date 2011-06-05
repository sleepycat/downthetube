module Youtube
  class Playlist
    #TODO reduce the duplication between this and the video class

    #include Naming from ActiveRecord if its here.
    begin
      self.extend ActiveModel::Naming
    rescue NameError => e
      #do nothing 
    end
  
    attr_reader :url
  
    def initialize entry

      define_attrs

      if ((entry) && (entry.class == REXML::Element))
        @xml = entry
        populate_attrs

      elsif((entry.class==String)&&(entry =~ /\w{16}/))
        @url = "http://gdata.youtube.com/feeds/api/playlists/#{entry}"
      else
        raise "The Playlist class did not understand the parameter it was initialized with."
      end
    end

    def populate_attrs
        @client ||= GData::Client::YouTube.new
        @xml ||= @client.get(self.url).to_xml

        @id = @xml.get_text('yt:playlistId')
        @title =  @xml.get_text('title')
        @author =  @xml.get_text('author/name')
        @xml.each_element_with_attribute('src'){|a| @url = a.attribute('src').to_s }
    end


    def define_attrs
      [:title, :author, :id].each do |attr|
        method_def = <<-EOM
          def #{attr}
            if @#{attr}
              @#{attr}
            else
              populate_attrs
              @#{attr}
            end
          end
        EOM
        class_eval method_def
      end
    end
  
    def self.name
      "Playlist"
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
end
