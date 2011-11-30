require 'spec_helper'

describe Youtube::Video do

  it "can be initialized with a video id" do 
    @vid = REXML::Document.new(File.read("spec/feeds/historia_and_documentario_playlist.xml")).root.elements['entry']
    response = double(GData::HTTP::Response, :to_xml => @vid)
    gd = double(GData::Client::YouTube, :get => response)
    GData::Client::YouTube.should_receive(:new).and_return(gd)

    video = Youtube::Video.new("pDY4EhXxPFE")
    video.title.should eql("Besouro Preto (Black Beetle)")
    video.id.should eql("pDY4EhXxPFE")
    video.description.should eql("Fragmento del documental Besouro Preto (Black Beetle) de Salim Rollins.\nhttp://www.arteafrikano.blogspot.com")
    video.uploader.should eql("rojococo")
    video.url.should eql("http://www.youtube.com/watch?v=pDY4EhXxPFE")
    video.duration.should eql("592")
  end

  it "can be initalized with a rexml element" do 
    besouro_vid = REXML::Document.new(File.read("spec/feeds/besouro_video.xml")).root

    video = Youtube::Video.new(besouro_vid)
    video.title.should eql("Besouro Preto (Black Beetle)")
    video.id.should eql("pDY4EhXxPFE")
    video.description.should eql("Fragmento del documental Besouro Preto (Black Beetle) de Salim Rollins.\nhttp://www.arteafrikano.blogspot.com")
    video.uploader.should eql("rojococo")
    video.url.should eql("http://www.youtube.com/watch?v=pDY4EhXxPFE")
    video.duration.should eql("592")

  end

  it "should provide a url to a large thumbnail when specified" do
    besouro_vid = REXML::Document.new(File.read("spec/feeds/besouro_video.xml")).root

    video = Youtube::Video.new(besouro_vid)
    video.thumbnail.should =~ /default.jpg/
    video.thumbnail(:large).should =~ /hqdefault.jpg/
  end

  it "should not include internal cruft in to_h" do
    besouro_vid = REXML::Document.new(File.read("spec/feeds/besouro_video.xml")).root

    video = Youtube::Video.new(besouro_vid)
    video.to_h.keys.should_not include(:xml, :client) 
  end

end

