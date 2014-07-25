class RemoveSourceTimestampFromPalettes < ActiveRecord::Migration
  def change
    remove_column :palettes, :source_timestamp, :timestamp
  end
end
