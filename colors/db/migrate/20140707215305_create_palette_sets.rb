class CreatePaletteSets < ActiveRecord::Migration
  def change
    create_table :palette_sets do |t|
      t.string :title
      t.references :user, index: true

      t.timestamps
    end
  end
end
