require 'spec_helper'

describe Youtube::Playlist do

  it "can be initalized with a playlist id" do
    @doc = REXML::Document.new(File.read("spec/feeds/historia_and_documentario_playlist.xml")).root
    response = double(GData::HTTP::Response, :to_xml => @doc)
    gd = double(GData::Client::YouTube, :get => response)
    GData::Client::YouTube.should_receive(:new).and_return(gd)

    pl = Youtube::Playlist.new("281715DB20526F2B")
    pl.title.should eql("Historia & Documentario")
    pl.id.should eql("281715DB20526F2B")
  end

  it "can be initialized with a rexml element" do 
    doc = REXML::Document.new(File.read("spec/feeds/playlists_for_stephensam.xml")).root
    # return the first entry element from doc:
    pl = Youtube::Playlist.new(doc.elements['entry'])
    pl.title.should == "Historia & Documentario"
    pl.id.should eql("281715DB20526F2B")
  end

  it "returns an array of videos" do
    @doc = REXML::Document.new(File.read("spec/feeds/historia_and_documentario_playlist.xml")).root
    response = double(GData::HTTP::Response, :to_xml => @doc)
    gd = double(GData::Client::YouTube, :get => response)
    GData::Client::YouTube.should_receive(:new).and_return(gd)
    # return the first entry element from doc:
    pl = Youtube::Playlist.new(@doc.elements['entry'])
    pl.videos.should have(19).videos
  end

  it "limits the number of videos returned" do
    @doc = REXML::Document.new(File.read("spec/feeds/historia_and_documentario_playlist.xml")).root
    response = double(GData::HTTP::Response, :to_xml => @doc)
    gd = double(GData::Client::YouTube, :get => response)
    GData::Client::YouTube.should_receive(:new).and_return(gd)
    # return the first entry element from doc:
    pl = Youtube::Playlist.new(@doc.elements['entry'])
    pl.videos(5).should have(5).videos
  end

end
