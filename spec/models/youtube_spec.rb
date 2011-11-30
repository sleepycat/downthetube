require 'spec_helper'

describe Youtube do

  before do
    @rexml_doc = REXML::Document.new(File.read('spec/feeds/playlists_for_stephensam.xml')).root
  end

  it "should return array of playlists for a given username" do
    yt = mock()
    yt.should_receive(:feed_for).with("stephensam").and_return(@rexml_doc)
    Youtube::YT.should_receive(:new).and_return(yt)

    Youtube.playlists_for("stephensam").should have(6).playlists
  end
  
  it "should raise an error if it doesn't find anything" do

    gd = double(GData::Client::YouTube, :get => lambda{raise GData::Client::UnknownError "test" })
    GData::Client::YouTube.should_receive(:new).and_return(gd)

    lambda{
      Youtube.playlists_for("test")
    }.should raise_error(Youtube::RetrievalError)
  end

end
