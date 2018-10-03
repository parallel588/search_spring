require 'excon'
require 'faraday'
require 'multi_json'

require_relative 'search_spring/version'
require_relative 'search_spring/client'

module SearchSpring
  DEFAULT_CA_BUNDLE_PATH = File.dirname(__FILE__) + '/data'
end
