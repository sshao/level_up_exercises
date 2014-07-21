require 'webmock/cucumber'
require_relative '../../spec/helpers'

WebMock.disable_net_connect!(allow_localhost: true)

World(Helpers)

