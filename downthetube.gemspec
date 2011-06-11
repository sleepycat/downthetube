specification = Gem::Specification.new do |spec|
  # Descriptive and source information for this gem.
  spec.name = "downthetube"
  spec.version = "0.0.7"
  spec.description = "A library to make downloading playlists and videos from Youtube less nasty."
  spec.summary = "Downloads playlists and videos from Youtube."
  spec.author = "Mike Williamson"
  spec.email = "blessedbyvirtuosity@gmail.com"
  spec.homepage = ""
  require 'rake'
  spec.files = %w(README lib/downthetube.rb lib/youtube.rb lib/video.rb lib/play_list.rb downthetube.gemspec)
  spec.has_rdoc = false
  spec.add_dependency("gdata", ">= 1.0.0")
  spec.extra_rdoc_files = ["README"]
  spec.require_path = ["lib"]
  #spec.test_files = ["spec"]
end

