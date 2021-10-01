# order matters
require "dosespot/configuration"
require "dosespot/request"
require "dosespot/restful_resource"
require "dosespot/response"
require "dosespot/version"

resources_path = File.expand_path('dosespot/resources/*.rb', File.dirname(__FILE__))
Dir[resources_path].each { |f| require f[/\/lib\/(.+)\.rb$/, 1] }

require 'active_support/core_ext/hash'

module Dosespot

  class AuthError < StandardError; end
  class AccessTokenNotPresentError < StandardError; end
  class InvalidApiUrlError < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

end
