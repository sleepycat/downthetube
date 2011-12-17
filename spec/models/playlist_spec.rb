require 'spec_helper'

describe Youtube::Playlist do
  before do

    @doc = REXML::Document.new(File.read("spec/feeds/historia_and_documentario_playlist.xml")).root

    @response = double(GData::HTTP::Response, :to_xml => @doc)
    @gd_client = double(GData::Client::YouTube, :get => @response)

    @pl = Youtube::Playlist.new("281715DB20526F2B")
    @pl.instance_variable_set(:@client, @gd_client)
  end

  it "can be initalized with a playlist id" do
    @gd_client.should_receive(:get)
    .with("http://gdata.youtube.com/feeds/api/playlists/281715DB20526F2B")
    @pl.title.should eql("Historia & Documentario")
    @pl.id.should eql("281715DB20526F2B")
  end

  it "can be initialized with a rexml element" do 
    doc = REXML::Document.new(File.read("spec/feeds/playlists_for_stephensam.xml")).root
    # return the first entry element from doc:
    pl = Youtube::Playlist.new(doc.elements['entry'])
    pl.title.should == "Historia & Documentario"
    pl.id.should eql("281715DB20526F2B")
  end

  it "returns an array of videos" do
    # return the first entry element from doc:
    @pl.videos.should have(19).videos
  end

  it "limits the number of videos returned" do
    # return the first entry element from doc:
    @pl.videos(5).should have(5).videos
  end

end
