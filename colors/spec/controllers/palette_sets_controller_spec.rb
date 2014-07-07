require 'rails_helper'

describe PaletteSetsController do
  describe "POST create" do
    context "with valid username" do
      let(:username) { "blog" }

      it "saves the new palettes in the database" do
        expect { post :create, blog: username }.to change(PaletteSet, :count).by(5)
      end

      it "redirects to the new palettes page"
    end

    context "with invalid username" do
      it "does not save the new palettes in the database"
      it "re-renders the :index template"
    end
  end
end

