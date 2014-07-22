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

  describe "GET index" do
    it "assigns an array of palette_sets" do
      p = FactoryGirl.create(:palette_set)
      get :index
      expect(assigns(:palette_sets)).to eq [p]
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET show" do
    it "renders the show template" do
      palette_set = FactoryGirl.create(:palette_set)
      get :show, id: palette_set.id
      expect(response).to render_template :show
    end
  end

  describe "GET new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template :new
    end
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

      it "redirects to the :new template" do
        post :create, palette_set: invalid_params
        expect(response).to render_template :new
      end
    end
  end
end

