class RemoveUserFromPaletteSet < ActiveRecord::Migration
  def change
    remove_column :palette_sets, :user_id, :integer
  end
end
