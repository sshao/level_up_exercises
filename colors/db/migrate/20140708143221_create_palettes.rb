class CreatePalettes < ActiveRecord::Migration
  def change
    create_table :palettes do |t|
      t.text :colors
      t.text :sources
      t.text :image_url
      t.timestamp :source_timestamp

      t.timestamps
    end
  end
end
