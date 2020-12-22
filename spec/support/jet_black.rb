require "jet_black"
require "jet_black/rspec"

JetBlack.configure do |config|
  config.path_prefix = File.expand_path("../../exe", __dir__)
end
