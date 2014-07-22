require 'webmock/cucumber'
require_relative '../../spec/connection_helpers'

WebMock.disable_net_connect!(allow_localhost: true)

World(ConnectionHelpers)

