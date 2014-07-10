class RemoveSourceFromPaletteSet < ActiveRecord::Migration
  def change
    remove_column :palette_sets, :source, :string
  end
end
