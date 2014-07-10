class AddSourceToPaletteSet < ActiveRecord::Migration
  def change
    add_column :palette_sets, :source, :string
    add_index :palette_sets, :source, unique: true
  end
end
