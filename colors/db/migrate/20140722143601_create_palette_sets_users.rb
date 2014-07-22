class CreatePaletteSetsUsers < ActiveRecord::Migration
  def change
    create_join_table :palette_sets, :users do |t|
      # t.index [:palette_set_id, :user_id]
      # t.index [:user_id, palette_set_id]
    end
  end
end
