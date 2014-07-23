require 'rails_helper'
require_relative '../connection_helpers'

describe PaletteSetsController do
  let(:username) { FactoryGirl.attributes_for(:palette_set)[:source] }

  RSpec.configure do |c|
    c.include ConnectionHelpers
  end

  before(:each) do
    stub_info_request(username)
    stub_photos_request(username, PULL_LIMIT)
  end

  describe "POST create" do
    let(:valid_params) { FactoryGirl.attributes_for(:palette_set) }

    context "with valid username" do
      it "saves the new palette set in the database" do
        expect { post :create, palette_set: valid_params }
          .to change(PaletteSet, :count)
          .by(1)
      end

      it "redirects to the new palette set page" do
        post :create, palette_set: valid_params
        expect(response).to redirect_to PaletteSet.last
      end

      context "that has already had palettes generated for it" do
        before(:each) do 
          PaletteSet.create!(valid_params)
        end

        it "does not save a new palette set in the database" do
          expect { post :create, palette_set: valid_params }
            .to_not change(PaletteSet, :count)
        end
        
        it "redirects to the existing palettes" do
          post :create, palette_set: valid_params
          expect(response).to redirect_to PaletteSet.find_by(source: username)
        end
      end
    end

    context "with invalid username" do
      let(:invalid_params) { FactoryGirl.attributes_for(:invalid_palette_set) }
      let(:username) { invalid_params[:source] }

      it "does not save the new palette set in the database" do
        expect { post :create, palette_set: invalid_params }
          .to_not change(PaletteSet, :count)
      end

      it "re-renders to the :new template" do
        post :create, palette_set: invalid_params
        expect(response).to render_template :new
      end
    end
  end
end

