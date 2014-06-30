require File.join(File.dirname(__FILE__), *%w[.. .. app])

require 'capybara'
require 'capybara/cucumber'
require 'rspec'

Capybara.app = Sinatra::Application.new

