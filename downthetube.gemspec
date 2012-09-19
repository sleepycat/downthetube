specification = Gem::Specification.new do |spec|
  # Descriptive and source information for this gem.
  spec.name = "downthetube"
  spec.version = "1.0.2"
  spec.description = "A library to make downloading playlists and videos from Youtube less nasty."
  spec.summary = "Downloads playlists and videos from Youtube."
  spec.author = "Mike Williamson"
  spec.email = "blessedbyvirtuosity@gmail.com"
  spec.homepage = "http://mikewilliamson.wordpress.com"
  spec.files = %w(README CHANGELOG.md Gemfile Gemfile.lock lib/downthetube.rb lib/downthetube/youtube.rb lib/downthetube/video.rb lib/downthetube/play_list.rb downthetube.gemspec)
  spec.has_rdoc = true
  spec.add_dependency("gdata_19", ">= 1.0.0")
  spec.extra_rdoc_files = ["README"]
  spec.require_paths = ["lib"]
  spec.test_files = ["spec"]
end

