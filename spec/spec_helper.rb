require File.expand_path '../../lib/akamai_api', __FILE__
require File.expand_path '../../lib/akamai_api/cli', __FILE__

begin
  require File.expand_path '../auth.rb', __FILE__
rescue LoadError
  AkamaiApi.config[:auth] = ['USERNAME', 'PASSWORD']
  AkamaiApi.config[:log] = true
  AkamaiApi.config[:openapi] = {
    :base_url => "https://some-subdomain.purge.akamaiapis.net",
    :client_token => "client_token",
    :client_secret => "client_secret",
    :access_token => "access_token"
  }
end
require 'savon/mock/spec_helper'
require 'webmock/rspec'
require 'vcr'
require 'coveralls'
Coveralls.wear_merged!

VCR.configure do |c|
  c.cassette_library_dir = 'cassettes'
  c.hook_into :webmock
  c.default_cassette_options = {
    match_requests_on: [:method, :uri, :body]
  }
  c.configure_rspec_metadata!
  c.after_http_request do |request|
    request.uri.gsub! AkamaiApi.config[:auth].first, 'USERNAME'
    request.uri.gsub! AkamaiApi.config[:auth].last, 'PASSWORD'
    request.body.gsub! "AkamaiApi #{AkamaiApi::VERSION}", "AkamaiApi VERSION"
  end
  c.before_playback do |i|
    i.request.uri.gsub! 'USERNAME', AkamaiApi.config[:auth].first
    i.request.uri.gsub! 'PASSWORD', AkamaiApi.config[:auth].last
    i.request.body.gsub! "AkamaiApi VERSION", "AkamaiApi #{AkamaiApi::VERSION}"
  end
end

# Savon::Spec::Fixture.path = File.expand_path '../fixtures', __FILE__
Dir[File.expand_path '../support/**/*.rb', __FILE__].each do |f|
  require f
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end
