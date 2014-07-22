require 'rails_helper'
require_relative '../helpers'

describe UsersController do
  RSpec.configure do |config|
    config.include Helpers
    config.include Devise::TestHelpers, :type => :controller
  end

  before(:each) do 
    @user = FactoryGirl.create(:user)
    sign_in @user

    stub_info_request(FactoryGirl.attributes_for(:palette_set)[:source])
    stub_photos_request(FactoryGirl.attributes_for(:palette_set)[:source], PULL_LIMIT)
  end

  describe "POST favorite" do
    let(:palette_set) { FactoryGirl.create(:palette_set) }

    it "redirects to the palette set" do
      post :favorite, id: palette_set.id
      expect(response).to redirect_to palette_set
    end

    it "adds the palette set to the current user's list of favorited sets" do
      expect { post :favorite, id: palette_set.id }
        .to change(@user.palette_sets, :count)
        .by(1)
    end
  end
end
