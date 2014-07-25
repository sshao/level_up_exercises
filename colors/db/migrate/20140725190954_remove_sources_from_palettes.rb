class RemoveSourcesFromPalettes < ActiveRecord::Migration
  def change
    remove_column :palettes, :sources, :text
  end
end
