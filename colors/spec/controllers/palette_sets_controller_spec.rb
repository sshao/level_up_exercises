require 'rails_helper'
require_relative '../helpers'

describe PaletteSetsController do
  RSpec.configure do |c|
    c.include Helpers
  end

  before(:each) do
    stub_10_photos_request
  end

  describe "POST new" do
    context "with valid username" do
      let(:username) { "blog" }

      it "saves the new palettes in the database"

      it "redirects to the new palettes page" do
        post :new, { tumblr_username: username }
        expect(response).to render_template "new"
      end
    end

    context "with invalid username" do
      it "does not save the new palettes in the database"
      it "re-renders the :index template"
    end
  end
end

