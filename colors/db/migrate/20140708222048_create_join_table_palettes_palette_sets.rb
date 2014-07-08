class CreateJoinTablePalettesPaletteSets < ActiveRecord::Migration
  def change
    create_join_table :palettes, :palette_sets do |t|
      # t.index [:palette_id, :palette_set_id]
      # t.index [:palette_set_id, :palette_id]
    end
  end
end
