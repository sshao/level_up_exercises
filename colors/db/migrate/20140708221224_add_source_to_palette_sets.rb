class AddSourceToPaletteSets < ActiveRecord::Migration
  def change
    add_column :palette_sets, :source, :string
  end
end
