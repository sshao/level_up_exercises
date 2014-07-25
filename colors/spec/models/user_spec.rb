require 'rails_helper'
require_relative '../connection_helpers'

describe User do
  RSpec.configure do |c|
    c.include ConnectionHelpers
  end
    
  before(:each) do 
    stub_info_request(username)
    stub_photos_request(username, PULL_LIMIT) 
  end

  describe "#palette_sets" do
    let(:username) { FactoryGirl.attributes_for(:palette_set)[:source] }
    let(:palette_set) { FactoryGirl.create(:palette_set)}

    it { should_not allow_value([palette_set, palette_set]).for(:palette_sets) }
  end
end

